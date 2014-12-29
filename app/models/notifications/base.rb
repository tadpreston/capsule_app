class Notifications::Base
  def initialize capsule
    @capsule = capsule
  end

  def process
    raise NotImplementedError
  end

  def create_notification message
    @capsule.recipients.each do |recipient|
      send_notification recipient, message
    end
  end

  def send_notification recipient, message
    notification = Notification.create capsule_id: @capsule.id,
                                       user_id: recipient.id,
                                       message: message,
                                       notification_type: message_type(recipient)
    notification.deliver
  end

  def message
    raise NotImplementedError
  end

  private

  def message_type recipient
    if recipient.device_token.blank?
      Notification::EMAIL
    else
      Notification::PUSH
    end
  end
end
