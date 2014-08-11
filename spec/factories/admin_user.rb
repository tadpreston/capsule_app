FactoryGirl.define do
  factory :admin_user do
    first_name 'Willie'
    last_name 'Jones'
    email
    password 'supersecret'
    password_confirmation 'supersecret'
  end
end
