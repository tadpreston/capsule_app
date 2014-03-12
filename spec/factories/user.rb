FactoryGirl.define do
  factory :user do
    email
    first_name 'Oscar'
    last_name 'Grouch'
    password 'supersecret'
    password_confirmation 'supersecret'
  end
end
