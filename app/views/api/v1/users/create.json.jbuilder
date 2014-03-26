if @user.errors.messages.any?
  envelope(json, :unprocessable_entity, @user.errors.messages) do
    json.partial! 'api/v1/users/user', user: @user
  end
else
  envelope(json, :created) do
    json.authentication_token @device.auth_token
    json.partial! 'api/v1/users/user', user: @user
  end
end
