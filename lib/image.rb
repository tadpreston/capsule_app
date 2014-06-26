class Image

  def initialize(aws_key, aws_bucket = ENV['S3_BUCKET_UPLOAD'])
    @aws_key = aws_key
    @aws_bucket = aws_bucket
    @access_key_id = ENV['AWS_ACCESS_KEY']
    @secret_access_key =  ENV['AWS_SECRET_KEY']

    @s3 = AWS::S3.new(access_key_id: @access_key_id, secret_access_key: @secret_access_key)
  end

  def size(aws_key = @aws_key)
    tmp_filename = "#{Rails.root}/tmp/#{aws_key}"

    copy_to_local(aws_key, tmp_filename)
    size = FastImage.size(tmp_filename)
    delete_local(tmp_filename)

    size
  end

  private

    def copy_to_local(source, destination)
      bucket = @s3.buckets[@aws_bucket]
      bucket.objects.with_prefix(source).each do |photo|
        File.open(destination,'wb') do |file|
          photo.read do |chunk|
            file.write chunk
          end
        end
      end
    end

    def delete_local(location)
      FileUtils.rm location
    end
end
