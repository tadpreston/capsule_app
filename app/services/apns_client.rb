class ApnsClient
  def initialize device_token
    raise ArgumentError, 'Device token cannot be blank' if device_token.blank?
    @file = ApnsCert.new.file
    @device_token = device_token
    initialize_client
  end

  def push message, badge=1
    APNS.send_notification @device_token, alert: message, badge: badge, sound: 'yada.wav'
  end

  private

  def initialize_client
    APNS.pem = @file
    APNS.host = ENV[APNS_HOST]
    APNS.port = 2195
  end

end
