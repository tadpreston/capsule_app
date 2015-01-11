class ApnsClient
  def initialize device_token, mode=''
    raise ArgumentError, 'Device token cannot be blank' if device_token.blank?
    @file = ApnsCert.new(mode).file
    @device_token = device_token
    @mode = mode
    initialize_client
  end

  def push message, badge=1
    APNS.send_notification @device_token, alert: message, badge: badge, sound: 'yada.wav'
  end

  private

  def initialize_client
    APNS.pem = @file
    APNS.host = ENV['APNS_HOST']
    APNS.host = ENV['APNS_HOST_DEV'] if @mode == 'test'
    APNS.port = 2195
  end

end
