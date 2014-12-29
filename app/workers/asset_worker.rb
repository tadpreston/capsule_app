class AssetWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform(asset_id)
    asset = Asset.find asset_id

    s3_resource = S3Resource.new asset.resource
    if s3_resource.exists?
      s3_resource.move_to_destination
      asset.update resource: s3_resource.storage_path
    else
      AssetWorker.perform_in 5.seconds, asset_id
    end
  end
end
