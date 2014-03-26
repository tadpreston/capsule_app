json.user do
  json.id user.public_id
  json.extract! user, :email, :first_name, :last_name
end
