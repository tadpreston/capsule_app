class UserProfileImageWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform(user_id)
    user = User.find user_id

    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    source_bucket = s3.buckets[ENV['S3_BUCKET_UPLOAD']]

    if source_bucket.objects[user.profile_image].exists?
      media_proc = MediaProc.new(user.profile_image)
      proc_response = media_proc.process

      user.update_columns(profile_image: media_proc.storage_path + user.profile_image, job_id: proc_response["assembly_id"])
    else
      AssetWorker.perform_in(15.seconds, user_id)
    end
  end

  def notify_url
    Rails.env == 'development' ? 'http://localhost/' : process_response_url(id, host: ENV['URL_HOST'], protocol: 'https')
  end
end
