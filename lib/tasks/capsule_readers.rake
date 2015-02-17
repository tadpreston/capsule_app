namespace :db do
  namespace :capsule do
    task :readers => :environment do
      Capsule.all.each do |capsule|
        capsule.read_array.each do |id|
          puts ">>> user : #{id} and capsule #{capsule.id} <<<"
          user = User.where(id: id).take
          if user
            capsule.readers << user
            puts "Updated capsule #{capsule.id} - user #{user.id}"
          end
        end
      end
    end
  end
end
