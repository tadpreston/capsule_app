class CapsuleLocationWatchWorker

  include Sidekiq::Worker

  def perform(capsule_id)
    CapsuleLocationWatch.add_to_watched_locations(capsule_id)
  end
end
