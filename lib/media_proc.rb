class MediaProc
  attr_accessor :storage_path

  def initialize(file_path, options = {})
    @file_path = FileUri.new(file_path)
    @options = options

    @transloadit = initialize_transloadit
    @storage_path = "#{SecureRandom.urlsafe_base64(32)}"
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
   case @file_path.extension
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

    options = {
      key: ENV['AWS_ACCESS_KEY'],
      secret: ENV['AWS_SECRET_KEY'],
      bucket: ENV['S3_BUCKET_UPLOAD'],
      path: "#{@file_path.key}/#{@file_path.filename}"
    }
    original = @transloadit.step('original', '/s3/import', options)

    options = {
        use: "original",
        width: 100,
        height: 100,
        strip: true
    }
    thumb = @transloadit.step('thumb', '/image/resize', options)

    options = {
      key: ENV['AWS_ACCESS_KEY'],
      secret: ENV['AWS_SECRET_KEY'],
      bucket: ENV['S3_BUCKET'],
      path: "#{@storage_path}/${previous_step.name}/${file.url_name}",
      use: ["original", "thumb"]
    }
    store = @transloadit.step('store', '/s3/store', options)

    assembly = @transloadit.assembly(steps: [original, thumb, store])
    assembly.submit!
  end

  def process_audio

    options = {
      key: ENV['AWS_ACCESS_KEY'],
      secret: ENV['AWS_SECRET_KEY'],
      bucket: ENV['S3_BUCKET_UPLOAD'],
      path: "#{@file_path.key}/#{@file_path.filename}"
    }
    original = @transloadit.step('original', '/s3/import', options)

    options = {
      use: "original",
      preset: "mp3"
    }
    encode = @transloadit.step('encode', '/audio/encode', options)

    options = {
      key: ENV['AWS_ACCESS_KEY'],
      secret: ENV['AWS_SECRET_KEY'],
      bucket: ENV['S3_BUCKET'],
      path: "#{@storage_path}/${previous_step.name}/${file.url_name}",
      use: ["original", "thumb"]
    }
    store = @transloadit.step('store', '/s3/store', options)

    assembly = @transloadit.assembly(steps: [original, encode, store])
    assembly.submit!
  end

  def process_video
    new_file_path = "https://#{@file_path.host}/#{ENV['S3_BUCKET']}/#{@storage_path}/#{@file_path.filename}"
    s3_file = S3File.new @file_path
    s3_file.move_to new_file_name
  end
end
