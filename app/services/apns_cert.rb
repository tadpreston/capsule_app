class ApnsCert
  attr_accessor :s3, :local_filename, :pem_filename

  EAST_BUCKET = 'capsule-app-internal'

  def initialize mode
    @s3 = Aws::S3::Client.new region: 'us-east-1', access_key_id: ENV['AWS_ACCESS_KEY_ID_EAST'],
                                     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_EAST']
    if mode == 'test'
      @pem_filename = ENV['APNS_PEM_FILE_NAME_DEV']
      @local_filename = Rails.root.join('tmp','apns',ENV['APNS_PEM_FILE_NAME_DEV'])
    else
      @pem_filename = ENV['APNS_PEM_FILE_NAME']
      @local_filename = Rails.root.join('tmp','apns',ENV['APNS_PEM_FILE_NAME'])
    end
  end

  def file
    get_file_from_remote
    File.new local_filename
  end

  def delete_file
    File.delete local_filename
  end

  private

  def get_file_from_remote
    FileUtils.mkdir_p Rails.root.join('tmp','apns')
    s3.get_object bucket: EAST_BUCKET, response_target: local_filename, key: pem_filename
  end
end
