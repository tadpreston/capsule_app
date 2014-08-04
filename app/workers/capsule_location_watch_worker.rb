class CapsuleLocationWatchWorker

  include Sidekiq::Worker

  def perform(capsule_id, tenant_id = 1)
    CapsuleLocationWatch.add_to_watched_locations(capsule_id, 1)
  end
end
