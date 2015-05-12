class Notifications::UnlockNotification < Notifications::Base
  def process
    @notification_type = Notification::UNLOCKED
    create_notification message if capsule.notifications.unlocked.empty?
  end

  def message
    'Hey! You just unlocked a Yada!'
  end
end
