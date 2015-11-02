# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  capsule_id        :integer
#  message           :text
#  notification_type :text
#  delivery_type     :text
#  notified          :boolean
#  created_at        :datetime
#  updated_at        :datetime
#

class Notification < ActiveRecord::Base
  NOTIFICATION_TYPES = [UNLOCKED = 'unlocked', NEW_YADA = 'new_yada', NEW_COMMENT = 'new_comment', READ_YADA = 'read_yada', FORWARDED_YADA = 'forwarded_yada']
  DELIVERY_TYPES = [EMAIL = 'email', PUSH = 'push', SMS = 'sms']

  belongs_to :user
  belongs_to :capsule

  delegate :device_token, to: :user
  delegate :mode, to: :user
  delegate :has_email?, to: :user
  delegate :has_device_token?, to: :user
  delegate :logged_in?, to: :user

  def self.new_yada
    where notification_type: NEW_YADA
  end

  def self.unlocked
    where notification_type: UNLOCKED
  end

  def deliver
    if delivery_type == PUSH
      deliver_push_notification
    else
      send "deliver_#{notification_type}_email_notification"
    end
  end

  def deliver_push_notification
    PushNotification.new(device_token, mode, { yada_id: capsule.id, yada_type: notification_type }).push(message) if pushable?
  end

  def deliver_new_yada_email_notification
    RecipientMailer.new_capsule(user_id, capsule_id, message).deliver if emailable?
  end

  def deliver_unlocked_email_notification
    RecipientMailer.unlocked_capsule(user_id, capsule_id).deliver if emailable?
  end

  def deliver_new_comment_email_notification
    CommentMailer.new_comment(user_id, capsule_id, message).deliver if emailable?
  end

  def deliver_read_yada_email_notification
    RecipientMailer.read_yada(user_id, capsule_id, message).deliver if emailable?
  end

  private

  def emailable?
    has_email?
  end

  def pushable?
    has_device_token? && logged_in?
  end
end
