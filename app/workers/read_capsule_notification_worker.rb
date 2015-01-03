class ReadCapsuleNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id, user_id)
    capsule = Capsule.unscoped.find capsule_id
    author = capsule.user
    user = User.unscoped.find user_id

    if author.device_token.blank?
      YadaMailer.yada_read(capsule_id, user_id).deliver
    else
      push_notification = PushNotification.new author.device_token
      push_notification.push "Your Yada has been read by #{user.full_name}"
    end
  end
end
