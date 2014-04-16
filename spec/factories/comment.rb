FactoryGirl.define do
  factory :comment do
    user
    capsule
    body 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
  end
end
