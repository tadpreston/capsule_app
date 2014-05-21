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
  end
end
