namespace :populate do
  task :destroy_all => :environment do
    [User, Capsule].each { |klass| klass.destroy_all }
  end

  task :users => :environment do
    300.times do
      user = User.new({
        email: Faker::Internet.email,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        phone_number: Faker::PhoneNumber.cell_phone,
        password: 'supersecret',
        password_confirmation: 'supersecret'
      })
      user.save
      puts "Creating user #{user.first_name} #{user.last_name}"
    end
  end

  task :capsules => :environment do
    User.all.each do |user|
      puts "Generating capsules for #{user.full_name}"
      geo = Location::GeoPoint.new({lat: 32.721701, long: -96.8983416}, 8046720) # 5000 miles
      rand(10).times do
        location = geo.get_point
        title = Faker::Commerce.product_name
        rand(4).times do
          title << " ##{Faker::Lorem.words[1]}"
        end
        user.capsules.create({
          title: title,
          location: { latitude: location[:lat], longitude: location[:lon], radius: 99999.0 }
        })
      end
    end
  end
end
