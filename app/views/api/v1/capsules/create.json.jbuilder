if @capsule.errors.messages.any?
  envelope(json, :unprocessable_entity, @capsule.errors.messages) do
    json.partial! 'api/v1/capsules/capsule', capsule: @capsule
  end
else
  envelope(json, :created) do
    json.partial! 'api/v1/capsules/capsule', capsule: @capsule
  end
end
