class NewCapsuleNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    capsule = Capsule.unscoped.find capsule_id
    author = capsule.user
    notify_recipients capsule, author
  end

  def notify_recipients capsule, author
    capsule.recipients.each do |recipient|
      if recipient.device_token
        push_notification = PushNotification.new recipient.device_token
        push_notification.push "You have received a PinYada from #{author.full_name}"
      end
    end
  end
end
