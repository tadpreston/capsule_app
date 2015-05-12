class CapsuleReadNotificationWorker
  include Sidekiq::Worker

  def perform capsule_read_id
    Notifications::CapsuleReadNotification.process capsule_read_id
  end
end
