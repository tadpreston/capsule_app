envelope(json, :success) do
  json.config do
    json.s3_bucket ENV['S3_BUCKET_UPLOAD']
    json.aws_access_key ENV['AWS_ACCESS_KEY']
    json.aws_access_secret ENV['AWS_SECRET_KEY']
    json.promotional_states Capsule::PROMOTIONAL_STATES do |p_state|
      json.set! :state, p_state
    end
    json.store_url 'https://itunes.apple.com/us/app/106-park/id418612824?mt=8'
    json.content_token_url 'capsule://?c=823879123'
    json.south_lat -60
    json.west_long -179.9
    json.north_lat 72
    json.east_long 179.9
    json.dmca_url 'http://capsuleapp.net/dmca'
    json.fetch_boundary_multiplier_for_map_rect "0.2"
    json.seconds_ahead_of_path_for_relative_capsules "45.0"
    json.max_jitter_for_relative_positions "0.1"
    json.seconds_until_picker_appears "2.0"
    json.max_video_duration "25.0"
    json.max_number_photos "4"
    json.marquee_pixels_per_second "80.0"
  end
end
