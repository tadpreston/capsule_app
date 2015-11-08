class CapsuleReadCallbacks
  def self.after_create capsule_read
    CapsuleReadNotificationWorker.perform_in 1.second, capsule_read.id
    relevance = Relevance.find_by capsule_id: capsule_read.capsule_id, user_id: capsule_read.capsule.user_id
    relevance.update_attributes relevant_date: Time.current if relevance
  end
end
