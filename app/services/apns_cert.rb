class ApnsCert
  attr_reader :mode

  WEST_BUCKET = 'pinyada'

  def initialize mode
    @mode = mode
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
    s3.get_object bucket: WEST_BUCKET, response_target: local_filename, key: "assets/certificates/#{pem_filename}"
  end

  def s3
    @s3 ||= Aws::S3::Client.new region: 'us-west-2', access_key_id: ENV['AWS_ACCESS_KEY_ID_WEST'],
                                secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_WEST']
  end

  def pem_filename
    if mode == 'test'
      ENV['APNS_PEM_FILE_NAME_DEV']
    else
      ENV['APNS_PEM_FILE_NAME']
    end
  end

  def local_filename
    Rails.root.join('tmp','apns', pem_filename)
  end
end
