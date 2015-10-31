class CapsuleWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    capsule = Capsule.find capsule_id
    if capsule.forwarded?
      Notification::ForwardedYadaNotification.new(capsule).process
    else
      Notifications::NewYadaNotification.new(capsule).process
    end
  end
end
