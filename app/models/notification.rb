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
  NOTIFICATION_TYPES = [EMAIL = 'email', PUSH = 'push', SMS = 'sms']

  belongs_to :user
  belongs_to :capsule

  delegate :device_token, to: :user, prefix: true

  def deliver
    send_push_notification if notification_type == PUSH
    send_email_notification if notification_type == EMAIL
  end

  def send_push_notification
    push_notification = PushNotification.new(user_device_token)
    push_notification.push message
  end

  def send_email_notification
    RecipientMailer.unlocked_capsule(user_id, capsule_id).deliver
  end
end
