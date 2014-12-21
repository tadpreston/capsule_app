namespace :populate do
  task :destroy_all => :environment do
    [User, Capsule].each { |klass| klass.destroy_all }
  end

  task :users, [:user_count] => :environment do |t, args|
    args.with_defaults(user_count: 300)
    puts args.user_count
    args.user_count.to_i.times do
      user = User.new({
        email: Faker::Internet.email,
        full_name: Faker::Name.first_name + ' ' + Faker::Name.last_name,
        phone_number: Faker::PhoneNumber.cell_phone,
        password: 'supersecret',
        password_confirmation: 'supersecret'
      })
      user.save
      puts "Creating user #{user.full_name}"
    end
  end

  task :capsules, [:lat, :long, :distance, :capsule_count]  => :environment do |t, args|
    args.with_defaults(lat: 32.721701, long: -96.8983416, distance: 8046720, capsule_count: 10)
    User.all.each do |user|
      puts "Generating capsules for #{user.full_name}"
      geo = Location::GeoPoint.new({lat: args.lat.to_f, long: args.long.to_f}, args.distance.to_i)
      rand(args.capsule_count.to_i).times do
        location = geo.get_point
        title = Faker::Commerce.product_name
        rand(4).times { title << " ##{Faker::Lorem.words[1]}" }
        user.capsules.create({
          title: title,
          location: { latitude: location[:lat], longitude: location[:lon], radius: 99999.0 }
        })
      end
    end
  end
end
