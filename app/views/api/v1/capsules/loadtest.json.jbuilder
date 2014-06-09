envelope(json, :success) do
  json.capsule_count @capsules.size
  json.set! :capsules do
    json.array! @capsules do |capsule|
      json.id capsule.id
      json.title capsule.title
      json.location capsule.location
      json.relative_location capsule.relative_location
      json.payload_type capsule.payload_type || 0
      json.thumbnail capsule.thumbnail_path
    end
  end
end
