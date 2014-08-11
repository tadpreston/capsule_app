class CapsuleLocationWatch
  def self.watch_capsules_at_location(location_watch_id, tenant_id = Tenant.current_id)
    Tenant.current_id = tenant_id

    location_watch = LocationWatch.find location_watch_id
    user = location_watch.user

    long = location_watch.longitude.to_f
    lat = location_watch.latitude.to_f
    radius = location_watch.radius.to_f

    capsules = Capsule.find_from_center({long: long, lat: lat}, {long: radius, lat: radius})
    capsules.each { |capsule| user.watch_capsule(capsule) unless user.is_watching_capsule?(capsule)  }

    Tenant.current_id = nil
  end

  def self.unwatch_capsules_at_location(location, user_id, tenant_id = Tenant.current_id)
    Tenant.current_id = tenant_id

    user = User.find(user_id)

    long = location['long'].to_f
    lat = location['lat'].to_f
    radius = location['radius'].to_f

    west_bound = long - radius
    east_bound = long + radius
    north_bound = lat + radius
    south_bound = lat - radius

    capsules = Capsule.where("watchers @> ARRAY[#{user_id}]").where(longitude: (west_bound..east_bound), latitude: (south_bound..north_bound))
    capsules.each { |capsule| capsule.unwatch user }

    Tenant.current_id = nil
  end

  def self.add_to_watched_locations(capsule_id)
    capsule = Capsule.unscoped.find(capsule_id)

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
