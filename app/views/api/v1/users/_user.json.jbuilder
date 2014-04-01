json.user do
  json.id user.public_id
  json.set! :user do
    json.email user.email
    json.username user.username
    json.first_name user.first_name
    json.last_name user.last_name
    json.location user.location
    json.time_zone user.time_zone || ''
    json.provider user.provider || ''
    json.uid user.uid || ''
    if user.oauth
      json.set! :oauth do
        json.provider user.oauth[:provider]
        json.uid user.oauth[:uid]
        json.info eval(user.oauth["info"])
        json.credentials eval(user.oauth["credentials"])
        json.extra eval(user.oauth["extra"])
      end
    end
  end
end
