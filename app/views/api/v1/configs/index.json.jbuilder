envelope(json, :success) do
  json.config do
    json.image_post_url ENV['CLOUDINARY_URL']
    json.aws do
      json.aws_access_key ENV['AWS_ACCESS_KEY']
      json.aws_secret_key ENV['AWS_SECRET_KEY']
      json.s3_bucket ENV['S3_BUCKET_UPLOAD']
    end
    json.redis do
      json.url ENV['REDISTOGO_URL']
    end
    json.payload_types Capsule::PAYLOAD_TYPES do |p_type|
      json.set! :type, p_type
    end
    json.promotional_states Capsule::PROMOTIONAL_STATES do |p_state|
      json.set! :state, p_state
    end
  end
end
