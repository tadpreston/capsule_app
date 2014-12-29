class AssetCallbacks
  def self.after_create asset
    s3_resource = S3Resource.new asset.resource
    if s3_resource.exists?
      s3_resource.move_to_destination
      asset.update resource: s3_resource.storage_path
    else
      AssetWorker.perform_in 5.seconds, asset_id
    end
  end
end
