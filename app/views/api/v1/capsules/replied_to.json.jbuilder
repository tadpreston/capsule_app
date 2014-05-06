envelope(json, :success) do
  json.capsule do
    if @capsule
      json.partial! 'api/v1/capsules/capsule', capsule: @capsule
    end
  end
end
