if @capsule.errors.messages.any?
  envelope(json, :unprocessable_entity, @capsule.errors.messages) do
    json.capsule do
      json.(@capsule, :id, :user_id, :title, :purged_title, :hash_tags, :location, :payload_type, :status, :promotional_state, :passcode, :visibility, :created_at, :updated_at)
    end
  end
else
  envelope(json, :updated) do
    json.capsule do
      json.(@capsule, :id, :user_id, :title, :purged_title, :hash_tags, :location, :payload_type, :status, :promotional_state, :passcode, :visibility, :created_at, :updated_at)
    end
  end
end
