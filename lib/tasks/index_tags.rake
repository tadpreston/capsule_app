namespace :db do
  task :index_tags => :environment do
    Capsule.all.each do |capsule|
      unless capsule.hash_tags.blank?
        hash_tags = capsule.hash_tags.split(' ')
        hash_tags.each do |tag|
          Hashtag.create(tag: tag, longitude: capsule.longitude, latitude: capsule.latitude)
        end
      end
    end
  end
end
