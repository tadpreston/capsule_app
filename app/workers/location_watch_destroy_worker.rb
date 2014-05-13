class LocationWatchDestroyWorker
  include Sidekiq::Worker

  def perform(location, user_id)
    CapsuleLocationWatch.unwatch_capsules_at_location(location, user_id)
  end
end
