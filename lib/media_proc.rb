class MediaProc
  include Rails.application.routes.url_helpers

  attr_accessor :storage_path

  def initialize(resource, options = {})
    @resource = resource
    @options = options

    @transloadit = initialize_transloadit
    @storage_path = "#{SecureRandom.urlsafe_base64(32)}/"
  end

  def process
    case media_type
    when 'image'
      process_image
    when 'audio'
      process_audio
    when 'video'
      process_video
    else
      ''
    end
  end

  def media_type
   case @resource[/[^.]*$/]
   when 'gif','jpg','jpeg','png'
     'image'
   when 'mp4','mov'
     'video'
   when 'mp3','aac','ogg','wma','wav','aiff'
     'audio'
   else
     ''
   end
  end

  def initialize_transloadit
    Transloadit.new(
      service: ENV['TRANSLOADIT_URL'],
      key: ENV['TRANSLOADIT_AUTH_KEY'],
      secret: ENV['TRANSLOADIT_SECRET_KEY']
    )
  end

  def process_image
    # Optimize the original by compressing and removing meta data
    options = {
      use: "original",
      preserve_meta_data: false
    }
    optimized = @transloadit.step('optimized', '/image/optimize', options)
    # Store optimized version
    options = {
      key: ENV['AWS_ACCESS_KEY'],
      secret: ENV['AWS_SECRET_KEY'],
      bucket: ENV['S3_BUCKET'],
      path: storage_path + "optimized/#{@resource}",
      use: "optimized"
    }
    store_optimized = @transloadit.step('store_optimized', '/s3/store', options)
    # Create an image with half the aspect ratio
    size = Image.new(@resource).size
    options = {
      use: "original",
      strip: true,
      width: (size[0] / 2),
      height: (size[1] / 2)
    }
    resize = @transloadit.step('resize', '/image/resize', options)
    # Store the resized image
    options = {
      key: ENV['AWS_ACCESS_KEY'],
      secret: ENV['AWS_SECRET_KEY'],
      bucket: ENV['S3_BUCKET'],
      path: storage_path + @resource,
      use: "resize"
    }
    store_resize = @transloadit.step('store_resize', '/s3/store', options)
    # Execute the steps
    submit_assembly [original, optimized, resize, store_resize, store_optimized, store_original]
  end

  def process_audio

    options = {
      use: "original",
      preset: "mp3"
    }
    encode = @transloadit.step('encode', '/audio/encode', options)

    options = {
      key: ENV['AWS_ACCESS_KEY'],
      secret: ENV['AWS_SECRET_KEY'],
      bucket: ENV['S3_BUCKET'],
      path: "#{@storage_path}/#{@resource}",
      use: "encode"
    }
    store_encode = @transloadit.step('store', '/s3/store', options)

    assembly = @transloadit.assembly(steps: [original, encode, store])
    assembly.submit!
    submit_assembly [original, encode, store_encode, store_original]
  end

  def process_video
    # Doing a copy from the source bucket to the destination
    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    source_bucket = s3.buckets[ENV['S3_BUCKET_UPLOAD']]
    dest_bucket = s3.buckets[ENV['S3_BUCKET']]
    source_obj = source_bucket.objects[@resource]
    dest_obj = dest_bucket.objects[storage_path]

    source_obj.copy_to(dest_obj, { acl: :public_read })
  end

  private

    def notify_url
      Rails.env == 'development' ? 'http://localhost/' : process_response_url(host: ENV['URL_HOST'], protocol: 'https')
    end

    def submit_assembly(steps)
      @transloadit.assembly(steps: steps, notify_url: notify_url).submit!
    end

    def original
      # Import the original for processing
      options = {
        key: ENV['AWS_ACCESS_KEY'],
        secret: ENV['AWS_SECRET_KEY'],
        bucket: ENV['S3_BUCKET_UPLOAD'],
        path: @resource
      }
      @transloadit.step('original', '/s3/import', options)
    end

    def store_original
      # Store the original
      options = {
        key: ENV['AWS_ACCESS_KEY'],
        secret: ENV['AWS_SECRET_KEY'],
        bucket: ENV['S3_BUCKET'],
        path: storage_path + "original/#{@resource}",
        use: "original"
      }
      @transloadit.step('store_original', '/s3/store', options)
    end
end
