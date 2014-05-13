module CapsuleLocationWatch
  def self.watch_capsules_at_location(location_watch_id)
    location_watch = LocationWatch.find location_watch_id
    user = location_watch.user

    long = location_watch.longitude.to_f
    lat = location_watch.latitude.to_f
    radius = location_watch.radius.to_f

    capsules = Capsule.find_from_center({long: long, lat: lat}, {long: radius, lat: radius})
    capsules.each { |capsule| user.watch_capsule(capsule) }
  end

  def self.unwatch_capsules_at_location(location, user_id)
    user = User.find(user_id)

    west_bound = location[:long] - location[:radius]
    east_bound = location[:long] + location[:radius]
    north_bound = location[:lat] + location[:radius]
    south_bound = location[:lat] - location[:radius]

    capsules = user.watched_capsules.where(longitude: (west_bound..east_bound), latitude: (south_bound..north_bound))
    capsules.each { |capsule| user.unwatch_capsule(capsule) }
  end
end
