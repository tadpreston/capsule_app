class CapsuleReadCallbacks
  def self.after_create capsule_read
    CapsuleReadNotificationWorker.perform_in 1.second, capsule_read.id
    relevance = Relevance.find_or_create_by capsule_id: capsule_read.capsule_id, user_id: capsule_read.capsule.user_id do |r|
      r.relevant_date = Time.current
    end
    relevance.update_attributes relevant_date: Time.current
  end
end
