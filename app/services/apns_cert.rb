class ApnsCert
  def initialize mode
    @s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    if mode == 'test'
      @pem_filename = ENV['APNS_PEM_FILE_NAME_DEV']
      @local_filename = "#{ENV['APNS_PEM_FILE_NAME_DEV']}"
    else
      @pem_filename = ENV['APNS_PEM_FILE_NAME']
      @local_filename = "#{ENV['APNS_PEM_FILE_NAME']}"
    end
  end

  def file
    get_file_from_remote
    File.new @local_filename
  end

  def delete_file
    File.delete @local_filename
  end

  private

  def bucket
    @bucket ||= @s3.buckets[ENV['APNS_BUCKET']]
  end

  def file_object
    @file_object ||= bucket.objects[@pem_filename]
  end

  def get_file_from_remote
    File.open(@local_filename, 'wb') do |file_out|
      file_object.read do |chunk|
        file_out.write(chunk)
      end
    end
  end
end
