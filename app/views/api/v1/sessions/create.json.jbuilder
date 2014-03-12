json.status 200
json.message 'User Authenticated'
json.set! :response do
  json.authentication_token @device.auth_token
end
