class ApnsCert
  attr_accessor :s3, :local_filename, :pem_filename

  WEST_BUCKET = 'pinyada'

  def initialize mode
    @s3 = Aws::S3::Client.new region: 'us-west-2', access_key_id: ENV['AWS_ACCESS_KEY_ID_WEST'],
                                     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_WEST']
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
    s3.get_object bucket: WEST_BUCKET, response_target: local_filename, key: "assets/certificates/#{pem_filename}"
  end
end
