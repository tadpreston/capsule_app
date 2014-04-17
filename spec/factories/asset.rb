FactoryGirl.define do
  factory :asset do
    capsule
    media_type 'image'
    resource 'http://imageurl.com'
  end
end
