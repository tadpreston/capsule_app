envelope(json, :success) do
  json.config do
    json.image_post_url "http://#{ENV['S3_BUCKET_UPLOAD']}.s3.amazonaws.com/"
    json.aws do
      json.access_key ENV['AWS_ACCESS_KEY']
      json.secret_key ENV['AWS_SECRET_KEY']
    end
    json.payload_types Capsule::PAYLOAD_TYPES do |p_type|
      json.set! :type, p_type
    end
    json.promotional_states Capsule::PROMOTIONAL_STATES do |p_state|
      json.set! :state, p_state
    end
  end
end
