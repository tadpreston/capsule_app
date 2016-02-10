class PushNotification
  attr_accessor :user_id, :message, :extra_data, :mode

  def initialize user_id, message, extra_data, mode
    @user_id = user_id
    @message = message
    @extra_data = extra_data
    @mode = mode
  end

  def self.push(user_id:, message:, extra_data:, mode: '')
    new(user_id, message, extra_data, mode).push
  end

  def push
    IosPush.push_message alert: message, user_id: user_id, other_data: extra_data
  end
end
