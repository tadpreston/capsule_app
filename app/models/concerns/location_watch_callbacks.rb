class LocationWatchCallbacks

  def self.after_create(location_watch)
    LocationWatchWorker.perform_async(location_watch.id)
  end
end
