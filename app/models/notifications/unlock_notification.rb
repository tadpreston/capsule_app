class Notifications::UnlockNotification
  def initialize capsule
    @capsule = capsule
  end

  def process
    create_notification if @capsule.notifications.empty?
  end

  def create_notification
    @capsule.recipients.each do |recipient|
      send_notification
    end
  end

  def send_notification recipient
    notification = Notification.create capsule_id: @capsule.id,
                                       user_id: recipient.id,
                                       message: 'A Yada has been unlocked for you!',
                                       message_type: message_type(recipient)
    notification.deliver
  end

  def message_type recipient
    if recipient.device_token.blank?
      Notification::EMAIL
    else
      Notification::PUSH
    end
  end
end
