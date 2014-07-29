namespace :db do
  task :normal => :environment do
    Capsule.all.each do |capsule|
      user = capsule.user
      user_hash = { id: user.id, first_name: user.first_name, last_name: user.last_name, profile_image: user.profile_image }
      capsule.update_attributes(creator: user_hash)
    end
  end
end
