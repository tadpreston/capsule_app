class Notifications::UnlockNotification < Notifications::Base
  def process
    create_notification(message) if @capsule.notifications.empty?
  end

  def message
    'A Yada has been unlocked for you!'
  end
end
