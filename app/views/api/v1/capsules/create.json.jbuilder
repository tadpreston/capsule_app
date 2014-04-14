if @capsule.errors.messages.any?
  envelope(json, :unprocessable_entity, @capsule.errors.messages) do
    json.capsule do
      json.(@capsule, :id, :user_id, :title, :purged_title, :hash_tags, :location, :payload_type, :status, :promotional_state, :lock_question, :lock_answer, :visibility, :created_at, :updated_at)
    end
  end
else
  envelope(json, :created) do
    json.capsule do
      json.(@capsule, :id, :user_id, :title, :purged_title, :hash_tags, :location, :payload_type, :status, :promotional_state, :lock_question, :lock_answer, :visibility, :created_at, :updated_at)
    end
  end
end
