class Notifications::CommentNotification < Notifications::Base
  attr_accessor :commenter_id, :commenter

  def initialize capsule_id, commenter_id
    @commenter_id = commenter_id
    @capsule = Capsule.unscoped.find capsule_id
    @commenter = User.find commenter_id
    @notification_type = Notification::NEW_COMMENT
  end

  def process
    notify_author unless capsule.user_id == commenter_id
    notify_recipients
  end

  def notify_author
    send_notification capsule.user, "#{commenter.full_name} commented on your Yada"
  end

  def notify_recipients
    capsule.recipients.each do |recipient|
      send_notification recipient, message if ok_to_send?(recipient)
    end
  end

  def message
    if commenter_id == capsule.user_id
      "#{commenter.full_name} commented on their own Yada"
    else
      "#{commenter.full_name} commented on #{capsule.user_full_name}'s Yada"
    end
  end

  private

  def ok_to_send? recipient
    capsule.is_unlocked?(recipient.id) && recipient.id != commenter_id
  end
end
