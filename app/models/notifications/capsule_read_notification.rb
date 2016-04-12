class Notifications::CapsuleReadNotification < Notifications::Base
  attr_accessor :capsule_read_id

  def self.process capsule_read_id
    new(capsule_read_id).process
  end

  def initialize capsule_read_id
    @notification_type = Notification::READ_YADA
    @capsule_read_id = capsule_read_id
  end

  def process
    send_notification capsule.user, message
  end

  def message
    "#{reader.full_name} opened the Yada you pinned to #{pinned_location}"
  end

  def reader
    @reader ||= capsule_read.user
  end

private

  def pinned_location
    capsule.start_date ? "#{capsule.start_date.strftime('%b %-d, %Y')}" : "#{capsule.location['name']}"
  end

  def capsule_read
    @capsule_read ||= CapsuleRead.find capsule_read_id
  end

  def capsule
    @capsule ||= capsule_read.capsule
  end
end
