class AssetWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform(asset_id)
    asset = Asset.find asset_id

    media_proc = MediaProc.new(asset.resource, notify_url: notify_url)

    media_proc_response = media_proc.process
    asset.process_response = media_proc_response.body
    asset.job_id = media_proc_response[:assembly_id]
    asset.storage_path = media_proc.storage_path
    asset.resource = FileUri.new(asset.resource).filename

    asset.save
  end

  def notify_url
    Rails.env == 'development' ? 'http://localhost/' : process_response_url(id, host: ENV['URL_HOST'], protocol: 'https')
  end
end
