envelope(json, :success) do
  json.config do
    json.image_post_url ENV['CLOUDINARY_URL']
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
