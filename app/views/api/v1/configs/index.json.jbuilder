envelope(json, :success) do
  json.config do
    json.s3_bucket ENV['S3_BUCKET_UPLOAD']
    json.aws_access_key ENV['AWS_ACCESS_KEY']
    json.aws_access_secret ENV['AWS_SECRET_KEY']
    json.promotional_states Capsule::PROMOTIONAL_STATES do |p_state|
      json.set! :state, p_state
    end
  end
end
