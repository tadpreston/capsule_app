class S3File
  attr_reader :file_uri, :path

  def initialize(uri)
    initialize_file(uri)
    @s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
  end

  def bucket
    @bucket ||= @s3.buckets[@file_uri.bucket]
  end

  def remove_file
    bucket.objects.with_prefix("#{object_path}/").delete_all
  end

  def object_path
    @object_path ||= @path.match(/^(?:\/)(.*)(?:\/)/)[1].match(/(?:\/)(.*)/)[1]
  end

  def move_to(destination)
    dest = FileUri.new destination
    dest_bucket = @s3.buckets[dest.bucket]
    source_obj = bucket.objects["#{@file_uri.key}/#{@file_uri.filename}"]
    dest_obj = dest_bucket.objects["#{dest.key}/#{dest.filename}"]
    source_obj.copy_to(dest_obj)

    remove_file

    initialize_file(destination)
  end

  def initialize_file(uri)
    @file_uri = FileUri.new uri
    @path = @file_uri.path
  end

  # this is to rename the filename so that we can control the filename and we can preserve the original file
  def copy_to_klfile
    new_filename = SecureRandom.urlsafe_base64 + '.' + @file_uri.extension

    source = bucket.objects["#{@file_uri.key}/#{@file_uri.filename}"]
    target = "#{@file_uri.key}/#{new_filename}"

    source.copy_to target, { acl: :public_read }

    new_filename
  end

end
