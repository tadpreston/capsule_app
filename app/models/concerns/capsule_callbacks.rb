class CapsuleCallbacks
  def self.before_save(capsule)
    if capsule.location
      capsule.latitude = capsule.location["latitude"] if capsule.location["latitude"]
      capsule.longitude = capsule.location["longitude"] if capsule.location["longitude"]
    end
  end

  def self.after_save(capsule)
    capsule.recipients.clear if capsule.recipients.empty?   # Assumption is that the recipient array sent in the capsule always represents the full list

    unless capsule.recipients_attributes.nil?
      recipients = capsule.recipients_attributes

      recipients.each do |recipient|
        user = Users::Search.find_or_create_recipient(recipient)
        capsule.add_as_recipient user
        capsule.user.add_as_contact user
      end
    end
  end

  def self.before_create(capsule)
    user = capsule.user
    capsule.creator = { id: user.id, full_name: user.full_name, profile_image: user.profile_image }
  end

  def self.after_create(capsule)
    CapsuleWorker.perform_in(1.second, capsule.id)
    UnlockNotificationWorker.perform_at(capsule.start_date, capsule.id) if capsule.start_date
  end
end
