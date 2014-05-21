namespace :db do
  task :location_boxes => :environment do
    Capsule.all.each do |capsule|
      origin = LocationBox.get_origin(capsule.latitude, capsule.longitude)
      location_box = LocationBox.find_or_create_by(latitude: origin[:latitude], longitude: origin[:longitude])
      cap_store = eval(location_box.capsule_store["ids"])
      cap_store << capsule.id
      location_box.capsule_store = { ids: cap_store }
      location_box.save
    end

    LocationBox.all.each do |location_box|
      ids = eval(location_box.capsule_store["ids"])
      sql = "SELECT median(latitude) AS lat_med, median(longitude) as long_med FROM capsules WHERE id IN (#{ids.join(',')})"
      c = Capsule.find_by_sql sql

      location_box.update_attributes(lat_median: c[0].lat_med, long_median: c[0].long_med)
    end
  end
end
