class S3Resource
  def initialize resource
    @resource = resource
    @s3 = AWS::S3.new access_key_id: ENV['AWS_ACCESS_KEY'], secret_access_key: ENV['AWS_SECRET_KEY']
  end

  def move_to_destination
    source_obj = source_bucket.objects[@resource]
    dest_obj = dest_bucket.objects[storage_path]
    source_obj.copy_to dest_obj
    source_bucket.objects.delete "#{@resource}"
  end

  def exists?
    source_bucket.objects[@resource].exists?
  end

  def source_bucket
    @source_bucket ||= @s3.buckets[ENV['S3_BUCKET']]
  end

  def dest_bucket
    @dest_bucket ||= @s3.buckets[ENV['S3_BUCKET']]
  end

  def storage_path
    @storage_path ||= "#{SecureRandom.urlsafe_base64(32)}/#{@resource}"
  end
end
