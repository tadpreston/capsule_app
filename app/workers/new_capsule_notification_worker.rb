class NewCapsuleNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    capsule = Capsule.find capsule_id
    Notifications::NewYadaNotification.new(capsule).process
  end
end
