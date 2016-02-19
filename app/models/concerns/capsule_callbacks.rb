class CapsuleCallbacks
  def self.before_save(capsule)
    if capsule.location
      capsule.latitude = capsule.location["latitude"] if capsule.location["latitude"]
      capsule.longitude = capsule.location["longitude"] if capsule.location["longitude"]
    end
  end

  def self.after_save(capsule)
    unless capsule.recipients_attributes.nil?
      recipients = capsule.recipients_attributes
      author = User::Blocker.find capsule.user_id

      recipients.each do |recipient|
        user = Users::Search.find_or_create_recipient(recipient)
        capsule.add_as_recipient user
        capsule.user.add_as_contact user
        unless user.id == capsule.user_id || author.is_blocked_by(user)
          capsule.relevances.create user_id: user.id, relevant_date: DateTime.now
        end
      end
    end

    capsule.relevances.create user_id: capsule.user_id, relevant_date: DateTime.now
  end

  def self.before_create(capsule)
    user = User.find capsule.user_id
    capsule.creator = { id: user.id, full_name: user.full_name, profile_image: user.profile_image }
  end

  def self.after_create(capsule)
    CapsuleWorker.perform_in(1.second, capsule.id)
    UnlockNotificationWorker.perform_at(capsule.start_date, capsule.id) if capsule.start_date
  end
end
