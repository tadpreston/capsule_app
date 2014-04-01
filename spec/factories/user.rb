FactoryGirl.define do
  factory :user do
    email
    username
    first_name 'Oscar'
    last_name 'Grouch'
    password 'supersecret'
    password_confirmation 'supersecret'
    provider 'capsule'
  end
end
