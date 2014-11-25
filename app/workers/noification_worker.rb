class NotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    capsule = Capsule.unscoped.find capsule_id

    capsule.recipients.each do |recipient|
      push_notification = PushNotification.new recipient.device_token
      push_notification.push 'You have a message from PinYada'
    end

  end
end
