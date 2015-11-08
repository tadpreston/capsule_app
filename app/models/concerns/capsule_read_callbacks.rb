class CapsuleReadCallbacks
  def self.after_create capsule_read
    CapsuleReadNotificationWorker.perform_in 1.second, capsule_read.id
    relavance(capsule_read.capsule).update_attributes relevant_date: DateTime.now
  end

  private
  
  private_class_method def self.relavance capsule
    Relevance.where(capsule_id: capsule.id, user_id: capsule.user_id).first
  end
end
