envelope(json, :success) do
  json.capsule do
    json.partial! 'api/v1/capsules/capsule', capsule: @capsule
  end
end
