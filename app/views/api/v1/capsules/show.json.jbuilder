envelope(json, :success) do
  json.capsule do
    json.partial! 'api/v1/capsules/capsule', capsule: @capsule
  end
  if @all_read
    json.tutorial_level_complete true
  end
end
