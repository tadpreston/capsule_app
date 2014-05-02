if @user.errors.messages.any?
  envelope(json, :unprocessable_entity, @user.errors.messages) do
    json.partial! 'api/v1/users/user', user: @user
  end
else
  envelope(json, :updated) do
    json.partial! 'api/v1/users/user', user: @user
  end
end
