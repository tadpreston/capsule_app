class PushNotification

  def initialize device_token
    raise ArgumentError, 'Device token cannot be blank' if device_token.blank?
    @client = ApnsClient.new device_token
  end

  def push message, badge=1
    @client.push message, badge
  end

end
