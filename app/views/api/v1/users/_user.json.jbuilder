json.user do
  json.set! :user do
    json.id user.id
    json.email user.email
    json.username user.username
    json.first_name user.first_name
    json.last_name user.last_name
    json.phone_number user.phone_number
    json.location user.location
    json.locale user.locale
    json.timezone user.time_zone || ''
    json.provider user.provider || ''
    json.uid user.uid || ''
  end
end
