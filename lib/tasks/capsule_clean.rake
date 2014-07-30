namespace :db do
  namespace :capsule do
    task :new_title => :environment do
      Capsule.all.each do |capsule|
        if capsule.thumbnail.include?('galaxy')
          capsule.update_attributes(title: 'We are not alone! #galaxy #spaceinvaders')
        elsif capsule.thumbnail.include?('kids')
          capsule.update_attributes(title: 'Summer fun with my kids and their cousins #kids #cousins #summerfun')
        elsif capsule.thumbnail.include?('flamingos')
          capsule.update_attributes(title: 'Colorful flamingo display at the city zoo #flamingos #cityzoo #inlivingcolor')
        elsif capsule.thumbnail.include?('donuts')
          capsule.update_attributes(title: 'Look what I had for breakfast! #donuts #breakfastofchampions #homer')
        elsif capsule.thumbnail.include?('marching')
          capsule.update_attributes(title: 'My son\'s freshman year in the marching band. #soproud #prouddad #uva')
        end
      end
    end

    task :remove_dups => :environment do
      Capsule.all.each do |capsule|
        capsules = Capsule.where(latitude: capsule.latitude, longitude: capsule.longitude)
        if capsules.count > 1
          capsules.each do |c|
            unless c.id == capsule.id
              puts "Removing capsule ID - #{c.id}"
              c.destroy
            end
          end
        end
      end
    end

  end
end
