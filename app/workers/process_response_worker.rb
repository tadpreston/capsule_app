class ProcessResponseWorker
  include Sidekiq::Worker

  def perform(asset_id)
    asset = Asset.find asset_id

    if asset.media_type == 'profile' || asset.media_type == 'background'
      user = asset.assetable
      if asset.media_type == 'profile'
        user.update_attribute(:profile_image, asset.resource)
      else
        user.update_attribute(:background_image, asset.resource)
      end
    end

    filename = asset.resource.split('/')[-1]
    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    source_bucket = s3.buckets[ENV['S3_BUCKET_UPLOAD']]
    source_bucket.objects.delete filename

  end
end
