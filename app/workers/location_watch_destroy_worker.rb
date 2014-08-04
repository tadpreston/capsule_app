class LocationWatchDestroyWorker
  include Sidekiq::Worker

  def perform(location, user_id, tenant_id)
    CapsuleLocationWatch.unwatch_capsules_at_location(location, user_id, tenant_id)
  end
end
