class AssetCallbacks
  def self.after_commit(asset)
    AssetWorker.perform_async(asset.id) if asset.job_id.blank?
  end
end
