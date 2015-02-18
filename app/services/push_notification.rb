class PushNotification

  def initialize device_token, user_mode='', other_data={}
    device_token.blank? and raise ArgumentError
    @client = ApnsClient.new device_token, user_mode, other_data
  end

  def push message, badge=1
    @client.push message, badge
  end

end
