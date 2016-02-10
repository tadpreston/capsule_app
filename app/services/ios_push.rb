class IosPush
  attr_accessor :alert, :user_id, :campaign, :sound, :badge, :other_data

  DEFAULT_SOUND = 'yada.wav'
  DEFAULT_BADGE = 1
  DEFAULT_CAMPAIGN = 'pinyada_notification'
  TARGET_TYPE = :customer_id
  APP_ID = ENV['LOCALYTICS_IOS_KEY']

  def initialize(alert, user_id, campaign, sound, badge, other_data)
    @alert = alert
    @user_id = user_id
    @campaign = campaign
    @sound = sound
    @badge = badge
    @other_data = other_data
  end

  def self.push_message(alert:, user_id:, other_data: nil, campaign: DEFAULT_CAMPAIGN, sound: DEFAULT_SOUND, badge: DEFAULT_BADGE)
    new(alert, user_id, campaign, sound, badge, other_data).push_message
  end

  def push_message
    client.push_to_customers [message], APP_ID, campaign
  rescue Localytics::Error => e
    puts e.cause
  end

  private

  def client
    return @client if @client
    Localytics.api_key = ENV['LOCALYTICS_API_KEY']
    Localytics.api_secret = ENV['LOCALYTICS_API_SECRET']
    @client = Localytics::Push
  end

  def message
    {
      target: user_id.to_s,
      alert: alert,
      ios: ios_message
    }
  end

  def ios_message
    ios = {
      sound: sound,
      badge: badge,
      content_available: true
    }
    if other_data
      ios.merge(extra: other_data)
    end
    ios
  end
end
