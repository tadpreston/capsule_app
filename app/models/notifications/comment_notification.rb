class Notifications::CommentNotification < Notifications::Base
  def process msg
    @notification_type = Notifications::NEW_COMMENT
    create_notification msg
  end

  def message
  end
end
