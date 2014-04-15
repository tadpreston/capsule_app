envelope(json, :success) do
  json.capsule do
    json.(@capsule, :id, :user_id, :title, :purged_title, :hash_tags, :location, :payload_type, :status, :promotional_state, :lock_question, :lock_answer, :visibility, :created_at, :updated_at)
  end
end
