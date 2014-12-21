FactoryGirl.define do
  factory :user do
    email
    username
    full_name 'Oscar Grouch'
    password 'supersecret'
    password_confirmation 'supersecret'
    provider 'capsule'
  end
end
