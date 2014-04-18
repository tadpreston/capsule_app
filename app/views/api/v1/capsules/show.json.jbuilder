envelope(json, :success) do
  json.capsule
    json.partial! 'api/v1/capsules/capsule', capsule: @capsule
  end
end
