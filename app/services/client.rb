class Client

  def initialize device_token
    raise ArgumentError, 'Device token cannot be blank' if device_token.blank?
    @device_token = device_token
    @client = initialize_client
  end

  def push message, badge=1, opt_args={}
    @client.register_device @device_token
    @client.push notification(message, badge, opt_args)
  end

  private

  def initialize_client
    c = Urbanairship::Client.new
    c.application_key = ENV['URBANAIR_APP_KEY']
    c.application_secret = ENV['URBANAIR_APP_SECRET']
    c.master_secret = ENV['URBANAIR_APP_MASTER_SECRET']
    c
  end

  def notification message, badge, opt_args
    {
      device_tokens: [@device_token],
      aps: {
        alert: message,
        badge: badge,
        sound: 'yada'
      }
    }.merge opt_args
  end

end
