class CapsuleCallbacks
  def self.before_save(capsule)
    capsule.hash_tags = capsule.title.split(/\s+|[;,]\s*/).select { |v| v[0] == '#' }.join(' ')

    capsule.latitude = capsule.location["latitude"] if capsule.location["latitude"]
    capsule.longitude = capsule.location["longitude"] if capsule.location["longitude"]
  end

  def self.after_save(capsule)
    capsule.recipients.clear if capsule.recipients.empty?

    unless capsule.recipients_attributes.nil?
#     recipients = capsule.recipients_attributes

      recipients.each do |recipient|
        user = User.find_or_create_by_phone_number(recipient[:phone_number], recipient)
        capsule.add_as_recipient user
        capsule.user.add_as_contact user
      end
    end
  end
end
