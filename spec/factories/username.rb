FactoryGirl.define do
  sequence :username do |n|
    "username#{n}"
  end
end
