class UnlockNotificationWorker
  include Sidekiq::Worker

  def perform capsule_id
    capsule = Capsule.unscoped.find capsule_id
    Notifications::UnlockCapsule.new(capsule).process
  end
end
