class LocationWatchDestroyWorker
  include Sidekiq::Worker

  def perform(location, user_id, tenant_id = 1)
    CapsuleLocationWatch.unwatch_capsules_at_location(location, user_id, 1)
  end
end
