class Notifications::Base
  attr_accessor :notification_type, :capsule

  def initialize capsule
    @capsule = capsule
  end

  def process
    raise NotImplementedError
  end

  def create_notification message
    user = User::Blocker.find capsule.user_id
    capsule.recipients.each do |recipient|
      unless user.is_blocked_by recipient
        send_notification recipient, message
      end
    end
  end

  def send_notification recipient, message
    notification = Notification.create capsule_id: capsule.id,
                                       user_id: recipient.id,
                                       message: message,
                                       notification_type: notification_type,
                                       delivery_type: message_type(recipient)
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
