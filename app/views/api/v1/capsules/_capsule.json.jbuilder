json.id capsule.id
json.set! :creator do
  json.id capsule.user.id
  json.email capsule.user.email
  json.username capsule.user.username
  json.full_name capsule.user.full_name
  json.first_name capsule.user.first_name
  json.last_name capsule.user.last_name
  json.phone_number capsule.user.phone_number
  json.location capsule.user.location
  json.locale capsule.user.locale
  json.timezone capsule.user.time_zone
  json.provider capsule.user.provider
  json.uid capsule.user.uid
  json.profile_image capsule.user.profile_image
end
json.title capsule.title
json.set! :hash_tags, capsule.hash_tags.split(' ')
json.location capsule.location
json.relative_location capsule.relative_location
json.payload_type capsule.payload_type || 0
json.status capsule.status
json.promotional_state capsule.promotional_state || 0
json.thumbnail capsule.thumbnail
json.set! :assets, capsule.assets
json.start_date '2014-04-02T11:12:13'
json.lock_question capsule.lock_question
json.lock_answer capsule.lock_answer
json.recipients capsule.recipients do |recipient|
  json.id recipient.id
  json.email recipient.email
  json.username recipient.username
  json.full_name recipient.full_name
  json.first_name recipient.first_name
  json.last_name recipient.last_name
  json.phone_number recipient.phone_number
  json.location recipient.location
  json.locale recipient.locale
  json.timezone recipient.time_zone
  json.provider recipient.provider
  json.uid recipient.uid
  json.profile_image recipient.profile_image
  json.recipient_token recipient.recipient_token
end
json.is_watched capsule.watched_by?(current_user)
json.is_incognito capsule.incognito || false
json.is_read capsule.read_by?(current_user)
json.created_at capsule.created_at
json.updated_at capsule.updated_at
