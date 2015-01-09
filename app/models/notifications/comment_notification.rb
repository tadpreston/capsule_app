class Notification::CommentNotification < Notification::Base
  def process msg
    @notification_type = Notification::NEW_COMMENT
    create_notification msg
  end

  def message
  end
end
