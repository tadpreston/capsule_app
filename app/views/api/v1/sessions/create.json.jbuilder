envelope(json, :user_authenticated) do
  json.authentication_token @device.auth_token
  json.partial! 'api/v1/users/user', user: @user
end
