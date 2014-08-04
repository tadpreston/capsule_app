class LocationWatchWorker
  include Sidekiq::Worker

  def perform(location_watch_id, tenant_id)
    CapsuleLocationWatch.watch_capsules_at_location(location_watch_id, tenant_id)
  end
end
