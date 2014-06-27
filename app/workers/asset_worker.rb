class AssetWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform(asset_id)
    asset = Asset.find asset_id

    unless asset.media_type == 'text'

      s3 = AWS::S3.new(
        access_key_id: ENV['AWS_ACCESS_KEY'],
        secret_access_key: ENV['AWS_SECRET_KEY']
      )
      source_bucket = s3.buckets[ENV['S3_BUCKET_UPLOAD']]

      if source_bucket.objects[asset.resource].exists?
        media_proc = MediaProc.new(asset.resource)
        proc_response = media_proc.process

        source_bucket.objects.delete(asset.resource)

        asset.update_attributes(resource: media_proc.storage_path + asset.resource, job_id: proc_response["assembly_id"])
      else
        AssetWorker.perform_in(15.seconds, asset_id)
      end

    end
  end

  def notify_url
    Rails.env == 'development' ? 'http://localhost/' : process_response_url(id, host: ENV['URL_HOST'], protocol: 'https')
  end
end
