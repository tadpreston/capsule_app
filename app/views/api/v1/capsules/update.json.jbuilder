if @capsule.errors.messages.any?
  envelope(json, :unprocessable_entity, @capsule.errors.messages) do
    json.capsule do
      json.partial! 'api/v1/capsules/capsule', capsule: @capsule
    end
  end
else
  envelope(json, :updated) do
    json.capsule do
      json.partial! 'api/v1/capsules/capsule', capsule: @capsule
    end
  end
end
