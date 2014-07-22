FactoryGirl.define do
  factory :asset do
    media_type 'image'
    resource 'http://imageurl.com'
    complete true
  end
end
