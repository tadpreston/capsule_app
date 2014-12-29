class Notifications::UnlockNotification < Notifications::Base
  def process
    @notification_type = Notification::UNLOCKED
    create_notification(message) if @capsule.notifications.unlocked.empty?
  end

  def message
    'A Yada has been unlocked for you!'
  end
end
