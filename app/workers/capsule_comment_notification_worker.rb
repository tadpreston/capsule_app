class CapsuleCommentNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id, commenter_id)
    capsule = Capsule.unscoped.find capsule_id
    commenter = User.find commenter_id

    notify_author capsule, commenter unless capsule.user_id == commenter_id
    notify_recipients capsule, commenter
  end

  def notify_author capsule, commenter
    Notification::CommentNotification.new(capsule).process "#{commenter.full_name} commented on your Yada"
  end

  def notify_recipients capsule, commenter
    capsule.recipients.each do |recipient|
      Notification::CommentNotification.new(capsule).process message(commenter, capsule) unless recipient.id == commenter.id
    end
  end

  def send_notification device_token, message
    push_notification = PushNotification.new device_token
    push_notification.push message
  end

  def message commenter, capsule
    if commenter.id == capsule.user_id
      "#{commenter.full_name} commented on their own Yada"
    else
      "#{commenter.full_name} commented on #{capsule.user_full_name}'s Yada"
    end
  end
end
