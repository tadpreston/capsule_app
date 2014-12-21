namespace :db do
  namespace :capsule do
    task :normalize_creator => :environment do
      Capsule.all.each do |capsule|
        puts "Capsule ID - #{capsule.id}"
        user = capsule.user
        user_hash = { id: user.id, full_name: user.full_name, profile_image: user.profile_image }
        capsule.update_attributes(creator: user_hash)
      end
    end
  end
end
