class UnlockNotificationWorker
  include Sidekiq::Worker

  def perform capsule_id
    capsule = Capsule.unscoped.find capsule_id
    Notifications::UnlockNotification.new(capsule).process
  end
end
