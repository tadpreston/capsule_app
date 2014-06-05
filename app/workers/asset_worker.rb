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
        storage_path = "#{SecureRandom.urlsafe_base64(32)}/#{asset.resource}"
        unless asset.media_type == 'audio'
          dest_bucket = s3.buckets[ENV['S3_BUCKET']]
          source_obj = source_bucket.objects[asset.resource]
          dest_obj = dest_bucket.objects[storage_path]

          source_obj.copy_to(dest_obj, { acl: :public_read })
          source_bucket.objects.delete(asset.resource)

          asset.update_attributes(resource: storage_path, complete: true)
        else

        end
      else
        AssetWorker.perform_in(30.seconds, asset_id)
      end

#      upload_path = "https://s3.amazonaws.com/#{ENV['S3_BUCKET_UPLOAD']}/#{asset.resource}"
#
#      media_proc = MediaProc.new(upload_path, notify_url: notify_url)
#
#      media_proc_response = media_proc.process
#      asset.process_response = media_proc_response.body
#      asset.job_id = media_proc_response[:assembly_id]
#      asset.storage_path = media_proc.storage_path
#      asset.resource = FileUri.new(asset.resource).filename
#
#      asset.save
#
#      s3_file = S3File.new(upload_path)
#      s3_file.remove_file
    end
  end

  def notify_url
    Rails.env == 'development' ? 'http://localhost/' : process_response_url(id, host: ENV['URL_HOST'], protocol: 'https')
  end
end
