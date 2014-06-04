class AssetWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform(asset_id)
    asset = Asset.find asset_id

    unless asset.media_type == 'text'
      upload_path = "https://s3.amazonaws.com/#{ENV['S3_BUCKET_UPLOAD']}/#{asset.resource}"

      media_proc = MediaProc.new(upload_path, notify_url: notify_url)

      media_proc_response = media_proc.process
      asset.process_response = media_proc_response.body
      asset.job_id = media_proc_response[:assembly_id]
      asset.storage_path = media_proc.storage_path
      asset.resource = FileUri.new(asset.resource).filename

      asset.save

      s3_file = S3File.new(upload_path)
      s3_file.remove_file
    end
  end

  def notify_url
    Rails.env == 'development' ? 'http://localhost/' : process_response_url(id, host: ENV['URL_HOST'], protocol: 'https')
  end
end
