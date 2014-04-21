json.id capsule.id
json.creator do
  json.id capsule.user.id
  json.email capsule.user.email || ''
  json.username capsule.user.username || ''
  json.full_name capsule.user.full_name || ''
  json.first_name capsule.user.first_name || ''
  json.last_name capsule.user.last_name || ''
  json.phone_number capsule.user.phone_number || ''
  json.location capsule.user.location || ''
  json.locale capsule.user.locale || ''
  json.timezone capsule.user.time_zone || ''
  json.provider capsule.user.provider || ''
  json.uid capsule.user.uid || ''
  json.profile_image capsule.user.profile_image || ''
end
json.title capsule.title || ''
json.set! :hash_tags, capsule.hash_tags.split(' ')
json.purged_title capsule.purged_title || ''
json.location capsule.location || ''
json.payload_type capsule.payload_type || 0
json.status capsule.status || ''
json.promotional_state capsule.promotional_state || 0
json.thumbnail capsule.thumbnail || ''
json.set! :assets, capsule.assets
json.set! :time_conditions do
  json.start_date '2014-04-02T11:12:13'
  json.set! :week_matrix do
    json.set! :monday, [{start: "8:00:00", end: "10:00:00"},{start: "12:00:00", end: "13:00:00"}]
    json.set! :tuesday, []
    json.set! :wednesday, []
    json.set! :thursday, [{start: "00:00:00", end: "23:59:59"}]
    json.set! :friday, []
    json.set! :satdurday, []
    json.set! :sunday, []
  end
  json.set! :repeat_pattern do
    json.interval 1
    json.count 1
  end
end
json.lock_question capsule.lock_question || ''
json.lock_answer capsule.lock_answer || ''
json.set! :recipients, []
