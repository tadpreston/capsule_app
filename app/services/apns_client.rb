class ApnsClient
  def initialize device_token
    @file = ApnsCert.new.file
    @device_token = device_token
    setup_gateway
  end

  def send message, badge=1
    APNS.send_notification @device_token, alert: message, badge: badge, sound: 'yada.wav'
  end

  private

  def setup_gateway
    APNS.pem = @file
    APNS.host = 'gateway.push.apple.com'
    APNS.port = 2195
  end

end
