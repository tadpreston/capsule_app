class CapsuleWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    capsule = Capsule.find capsule_id

    file_path = FileUri.new("https://s3.amazonaws.com/#{ENV['S3_BUCKET_UPLOAD']}/#{capsule.thumbnail}")
    storage_path = "#{SecureRandom.urlsafe_base64(32)}"

    new_file_path = "https://#{file_path.host}/#{ENV['S3_BUCKET']}/#{storage_path}/#{file_path.filename}"
    s3_file = S3File.new file_path
    s3_file.move_to new_file_name

    capsule.update_column(:thumbnail, "#{storage_path}/#{file_path.filename}")
  end
end
