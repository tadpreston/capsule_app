class Notifications::CapsuleReadNotification < Notifications::Base
  attr_reader :reader

  def self.process capsule_read_id
    new(capsule_read_id).process
  end

  def initialize capsule_read_id
    @notification_type = Notification::READ_YADA
    capsule_read = CapsuleRead.find capsule_read_id
    @capsule = capsule_read.capsule
    @reader = capsule_read.user
  end

  def process
    send_notification capsule.user, message
  end

  def message
    "#{reader.full_name} opened the Yada you pinned to #{pinned_location}"
  end

private

  def pinned_location
    capsule.start_date ? "#{capsule.start_date}" : "#{capsule.location['name']}"
  end
end
