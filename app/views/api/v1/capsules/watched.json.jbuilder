envelope(json, :success) do
  jason.array! @capsules do |capsule|
    json.(capsule, :id, :user_id, :title, :purged_title, :hash_tags, :location, :payload_type, :status, :promotional_state, :passcode, :visibility, :created_at, :updated_at)
  end
end
