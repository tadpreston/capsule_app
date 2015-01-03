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
  NOTIFICATION_TYPES = [UNLOCKED = 'unlocked', NEW_YADA = 'new_yada']
  DELIVERY_TYPES = [EMAIL = 'email', PUSH = 'push', SMS = 'sms']

  belongs_to :user
  belongs_to :capsule

  delegate :device_token, to: :user, prefix: true

  def self.new_yada
    where notification_type: NEW_YADA
  end

  def self.unlocked
    where notification_type: UNLOCKED
  end

  def deliver
    deliver_push_notification if delivery_type == PUSH
    send "deliver_#{notification_type}_email_notification" if delivery_type == EMAIL
  end

  def deliver_push_notification
    push_notification = PushNotification.new(user_device_token)
    push_notification.push message
  end

  def deliver_new_yada_email_notification
    RecipientMailer.new_capsule(user_id, capsule_id, message).deliver
  end

  def deliver_unlocked_email_notification
    RecipientMailer.unlocked_capsule(user_id, capsule_id).deliver
  end
end
