class CapsuleCallbacks
  def self.before_save(capsule)
    capsule.hash_tags = capsule.title.split(/\s+|[;,]\s*/).select { |v| v[0] == '#' }.join(' ')

    if capsule.location
      capsule.latitude = capsule.location["latitude"] if capsule.location["latitude"]
      capsule.longitude = capsule.location["longitude"] if capsule.location["longitude"]
    end
  end

  def self.after_save(capsule)
    capsule.recipients.clear if capsule.recipients.empty?   # Assumption is that the recipienst array sent in the capsule always represents the full list

    unless capsule.recipients_attributes.nil?
      recipients = capsule.recipients_attributes

      recipients.each do |recipient|
        user = Users::Search.find_or_create_recipient(recipient)
        capsule.add_as_recipient user
        capsule.user.add_as_contact user

        if user.phone_number.blank? || !user.can_send_text
          RecipientWorker.perform_in(5.seconds, user.id, capsule.id)
        end
      end
    end
  end

  def self.before_create(capsule)
    user = capsule.user
    capsule.creator = { id: user.id, first_name: user.first_name, last_name: user.last_name, profile_image: user.profile_image }
  end

  def self.after_create(capsule)
    CapsuleLocationWatchWorker.perform_in(2.seconds, capsule.id)
    CapsuleWorker.perform_in(15.seconds, capsule.id)
  end
end
