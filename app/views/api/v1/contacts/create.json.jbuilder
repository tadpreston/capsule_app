if @contact.errors.messages.any?
  envelope(json, :unprocessable_entity, @contact.errors.messages) do
    json.partial! 'api/v1/contacts/contact', contact: @contact
  end
else
  envelope(json, :created) do
    json.partial! 'api/v1/contacts/contact', contact: @contact
  end
end
