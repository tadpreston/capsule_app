envelope(json, :success) do
  json.capsule do
    json.partial! 'api/v1/capsules/capsule', capsule: @capsule
#    json.cache! ['api/v1/_capsule', @capsule] do
#    end
  end
end
