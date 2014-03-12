FactoryGirl.define do
  factory :device do
    user
    remote_ip '127.0.0.1'
    user_agent 'iPhone5'
  end
end
