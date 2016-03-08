class PushNotification
  attr_accessor :user_id, :alert, :extra_data, :mode, :campaign, :sound, :badge

  DEFAULT_SOUND = 'yada.wav'
  DEFAULT_BADGE = 1
  DEFAULT_CAMPAIGN = 'pinyada_notification'
  TARGET_TYPE = :customer_id
  APP_IDS = [ENV['LOCALYTICS_IOS_KEY'], ENV['LOCALYTICS_ANDROID_KEY']]

  def initialize alert, user_id, extra_data, mode, campaign, sound, badge
    @alert = alert
    @user_id = user_id
    @extra_data = extra_data
    @mode = mode
    @campaign = campaign
    @sound = sound
    @badge = badge
  end

  def self.push(alert:, user_id:, extra_data: nil, mode: '', campaign: DEFAULT_CAMPAIGN, sound: DEFAULT_SOUND, badge: DEFAULT_BADGE)
    new(alert, user_id, extra_data, mode, campaign, sound, badge).push
  end

  def push
    begin
      APP_IDS.each do |app_id|
        client.push_to_customers [message.merge(is_ios?(app_id) ? ios_message : android_message)], app_id, campaign
      end
    rescue Localytics::Error => e
      puts e.cause
    end
  end

  private

  def client
    return @client if @client
    Localytics.api_key = ENV['LOCALYTICS_API_KEY']
    Localytics.api_secret = ENV['LOCALYTICS_API_SECRET']
    @client = Localytics::Push
  end

  def message
    { target: user_id.to_s, alert: alert }
  end

  def ios_message
    { ios: {
      sound: sound,
      badge: badge,
      content_available: true,
      extra: extra_data
    } }
  end

  def android_message
    { android: { extra: extra_data } }
  end

  def is_ios? app_id
    ENV['LOCALYTICS_IOS_KEY'] == app_id
  end
end
