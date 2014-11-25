class CapsuleCommentNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id, commenter_id)
    capsule = Capsule.unscoped.find capsule_id
    commenter = User.find commenter_id

    notify_author capsule, commenter
    notify_commenters capsule, commenter
  end

  def notify_author capsule, commenter
    send_notification capsule.user_device_token, "#{commenter.full_name} commented on your Pin"
  end

  def notify_commenters capsule, commenter
    capsule.comments.each do |comment|
      unless comment.user_id == commenter.id
        send_notification comment.user_device_token, "#{commenter.full_name} also commented on #{capsule.user_full_name}'s Pin"
      end
    end
  end

  def send_notification device_token, message
    push_notification = PushNotification.new device_token
    push_notification.push message
  end
end
