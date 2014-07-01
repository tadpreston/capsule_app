FactoryGirl.define do
  factory :capsule do
    user
    title "the capsule title #withsomehashtag #anothertag #hellokitty"
    location { { latitude: '33.18953', longitude: '-96.8909', radius: '.02341' } }
    latitude 33.18953
    longitude -96.8909
    payload_type 'image'
    incognito false
  end
end
