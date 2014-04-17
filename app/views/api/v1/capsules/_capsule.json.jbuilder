json.capsule do
  json.id capsule.id
  json.creator do
    json.id capsule.user.id
    json.email capsule.user.email
    json.username capsule.user.username
    json.full_name capsule.user.full_name
    json.first_name capsule.user.first_name
    json.last_name capsule.user.last_name
    json.phone_number capsule.user.phone_number || ''
    json.location capsule.user.location
    json.locale capsule.user.locale
    json.timezone capsule.user.time_zone || ''
    json.provider capsule.user.provider || ''
    json.uid capsule.user.uid || ''
    json.profile_image capsule.user.profile_image || ''
  end
  json.title capsule.title
  json.set! :hash_tags, capsule.hash_tags.split(' ')
  json.purged_title capsule.purged_title
  json.location capsule.location
  json.payload_type capsule.payload_type
  json.status capsule.status
  json.promotional_state capsule.promotional_state
  json.lock_question capsule.lock_question
  json.lock_answer capsule.lock_answer
  json.visibility capsule.visibility
end
