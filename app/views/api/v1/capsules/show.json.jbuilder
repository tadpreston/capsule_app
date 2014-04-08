envelope(json, :success) do
  json.capsule do
    json.(@capsule, :id, :user_id, :title, :purged_title, :hash_tags, :location, :payload_type, :status, :promotional_state, :passcode, :visibility, :created_at, :updated_at)
  end
end
