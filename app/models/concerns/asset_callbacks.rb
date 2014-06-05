class AssetCallbacks
  def self.after_create(asset)
    AssetWorker.perform_in(30.seconds, asset.id)
  end
end
