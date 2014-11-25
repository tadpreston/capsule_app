class ReadCapsuleNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id, user_id)
    capsule = Capsule.unscoped.find capsule_id
    author = capsule.user
    user = User.unscoped.find user_id

    push_notification = PushNotification.new author.device_token
    push_notification.push "Your Pin has been read by #{user.full_name}"
  end
end
