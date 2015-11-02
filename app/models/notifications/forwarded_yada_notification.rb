class Notifications::ForwardedYadaNotification < Notifications::Base
  def process
    @notification_type = Notification::FORWARDED_YADA
    create_notification message
  end

  def message
   "A Yada has been forwarded to you from #{capsule.user_full_name}"
  end
end
