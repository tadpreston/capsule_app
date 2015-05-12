class CapsuleReadCallbacks
  def self.after_create capsule_read
    CapsuleReadNotificationWorker.perform_in 1.second, capsule_read.id
  end
end
