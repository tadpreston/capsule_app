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
      storage_path = "#{SecureRandom.urlsafe_base64(32)}/#{asset.resource}"

      if source_bucket.objects[asset.resource].exists?
        if asset.media_type == 'video'  # copy image and video objects from upload to storage bucket
          dest_bucket = s3.buckets[ENV['S3_BUCKET']]
          source_obj = source_bucket.objects[asset.resource]
          dest_obj = dest_bucket.objects[storage_path]

          source_obj.copy_to(dest_obj, { acl: :public_read })
          asset.update_attributes(resource: storage_path, complete: true)
        elsif asset.media_type == "image"  #process the image with transloadit
          transloadit = Transloadit.new(
            service: ENV['TRANSLOADIT_URL'],
            key: ENV['TRANSLOADIT_AUTH_KEY'],
            secret: ENV['TRANSLOADIT_SECRET_KEY']
          )

          options = {
            key: ENV['AWS_ACCESS_KEY'],
            secret: ENV['AWS_SECRET_KEY'],
            bucket: ENV['S3_BUCKET_UPLOAD'],
            path: asset.resource
          }
          original = transloadit.step('original', '/s3/import', options)

          options = {
            use: "original",
            preserve_meta_data: false
          }
          optimized = transloadit.step('optimized', '/image/optimize', options)

          options = {
            use: "original",
            strip: true,

          }
          resize = transloadit.step('reduced', '/image/resize', options)

          options = {
            key: ENV['AWS_ACCESS_KEY'],
            secret: ENV['AWS_SECRET_KEY'],
            bucket: ENV['S3_BUCKET'],
            path: storage_path,
            use: ["original","resize","optimized"]
          }
          store = transloadit.step('store', '/s3/store', options)

          assembly = transloadit.assembly(steps: [original, optimized, resize, store])
          assembly.submit!

          asset.update_attributes(resource: storage_path)
        else  # process audio with Transloadit
          transloadit = Transloadit.new(
            service: ENV['TRANSLOADIT_URL'],
            key: ENV['TRANSLOADIT_AUTH_KEY'],
            secret: ENV['TRANSLOADIT_SECRET_KEY']
          )

          options = {
            key: ENV['AWS_ACCESS_KEY'],
            secret: ENV['AWS_SECRET_KEY'],
            bucket: ENV['S3_BUCKET_UPLOAD'],
            path: asset.resource
          }
          original = transloadit.step('original', '/s3/import', options)

          options = {
            use: "original",
            preset: "mp3"
          }
          encode = transloadit.step('encode', '/audio/encode', options)

          options = {
            key: ENV['AWS_ACCESS_KEY'],
            secret: ENV['AWS_SECRET_KEY'],
            bucket: ENV['S3_BUCKET'],
            path: storage_path,
            use: ["original","encode"]
          }
          store = transloadit.step('store', '/s3/store', options)

          assembly = transloadit.assembly(steps: [original, encode, store])
          assembly.submit!

          asset.update_attributes(resource: storage_path)
        end

        source_bucket.objects.delete(asset.resource)
      else
        AssetWorker.perform_in(15.seconds, asset_id)
      end

    end
  end

  def notify_url
    Rails.env == 'development' ? 'http://localhost/' : process_response_url(id, host: ENV['URL_HOST'], protocol: 'https')
  end
end
