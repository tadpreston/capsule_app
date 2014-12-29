class CapsuleWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    NewCapsuleNotificationWorker.perform_async capsule_id
  end
end
