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
end
