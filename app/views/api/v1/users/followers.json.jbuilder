envelope(json, :success) do
  json.set! :followers do
    json.array! @users do |user|
      json.partial! 'api/v1/users/user', user: user
    end
  end
end
