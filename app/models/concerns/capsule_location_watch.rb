module CapsuleLocationWatch
  def self.watch_capsules_at_location(location_watch_id)
    location_watch = LocationWatch.find location_watch_id
    user = location_watch.user

    long = location_watch.longitude.to_f
    lat = location_watch.latitude.to_f
    radius = location_watch.radius.to_f

    capsules = Capsule.find_from_center({long: long, lat: lat}, {long: radius, lat: radius})
    capsules.each { |capsule| user.watch_capsule(capsule) unless user.is_watching_capsule?(capsule)  }
  end

  def self.unwatch_capsules_at_location(location, user_id)
    user = User.find(user_id)

    west_bound = location['long'] - location['radius']
    east_bound = location['long'] + location['radius']
    north_bound = location['lat'] + location['radius']
    south_bound = location['lat'] - location['radius']

    capsules = Capsule.where("watchers @> ARRAY[#{user_id}]").where(longitude: (west_bound..east_bound), latitude: (south_bound..north_bound))
    capsules.each { |capsule| capsule.unwatch user }
  end

  def self.add_to_watched_locations(capsule_id)
    capsule = Capsule.find(capsule_id)

    LocationWatch.find_each do |location|
      if in_range? capsule, location
        unless location.user_id == capsule.user_id
          capsule.watch location.user
        end
      end
    end
  end

  private

    def self.in_range?(capsule, location)
      west_bound = location.longitude.to_f - location.radius.to_f
      east_bound = location.longitude.to_f + location.radius.to_f
      north_bound = location.latitude.to_f + location.radius.to_f
      south_bound = location.latitude.to_f - location.radius.to_f

      (west_bound..east_bound).include?(capsule.longitude.to_f) && (south_bound..north_bound).include?(capsule.latitude.to_f)
    end
end
