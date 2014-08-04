class LocationWatchCallbacks

  def self.after_destroy(location_watch)
    lat = location_watch.latitude.to_f
    long = location_watch.longitude.to_f
    radius = location_watch.radius.to_f
    location = {'lat' => lat, 'long' => long, 'radius' => radius }
    LocationWatchDestroyWorker.perform_async(location, location_watch.user_id, Tenant.current_id)
  end
end
