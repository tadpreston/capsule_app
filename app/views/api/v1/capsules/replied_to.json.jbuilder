envelope(json, :success) do
  json.capsule do
    if @capsule
      json.cache! ['api/v1/_capsule', @capsule] do
        json.partial! 'api/v1/capsules/capsule', capsule: @capsule
      end
    end
  end
end
