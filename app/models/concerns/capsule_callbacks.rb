class CapsuleCallbacks
  def self.before_save(capsule)
    capsule.hash_tags = capsule.title.split(/\s+|[;,]\s*/).select { |v| v[0] == '#' }.join(' ')

    capsule.latitude = capsule.location["latitude"] if capsule.location["latitude"]
    capsule.longitude = capsule.location["longitude"] if capsule.location["longitude"]
  end

  def self.after_save(capsule)
    capsule.recipients.clear if capsule.recipients.empty?

    unless capsule.recipients_attributes.nil?
      recipients = capsule.recipients_attributes

      recipients.each do |recipient|
        user = User.find_or_create_by(phone_number: recipient[:phone_number]) do |user|
          user.email = recipient[:email]
          user.first_name = recipient[:first_name]
          user.last_name = recipient[:last_name]
          tmp_pwd = SecureRandom.hex
          user.password = tmp_pwd
          user.password_confirmation = tmp_pwd
        end
        capsule.recipients << user

        creator = capsule.user
        creator.contacts << user unless creator.contacts.exists?(user)
      end
    end
  end
end
