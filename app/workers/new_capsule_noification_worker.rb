class NewCapsuleNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    capsule = Capsule.unscoped.find capsule_id
    Notificcations::NewYadaNotification.new(capsule).process
  end
end
