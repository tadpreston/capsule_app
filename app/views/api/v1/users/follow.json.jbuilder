envelope(json, :success) do
  json.partial! 'api/v1/users/user', user: @follow_user
end
