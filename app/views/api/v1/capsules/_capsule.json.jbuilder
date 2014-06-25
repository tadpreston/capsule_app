json.id capsule.id
json.in_reply_to capsule.in_reply_to if capsule.in_reply_to
json.set! :creator do
  json.id capsule.cached_user.id
  json.full_name capsule.cached_user.full_name
  json.profile_image capsule.cached_user.profile_image
end
json.is_owned is_owned?(capsule.user_id)
json.title capsule.title
json.set! :hash_tags, capsule.hash_tags.split(' ')
json.location capsule.location
json.relative_location capsule.relative_location
json.payload_type capsule.payload_type || 0
json.status capsule.status
json.promotional_state capsule.promotional_state || 0
json.thumbnail capsule.thumbnail_path
json.assets capsule.cached_assets do |asset|
  json.media_type asset.media_type
  json.resource asset.media_type == "text" ? asset.resource : asset.resource_path
end
json.start_date capsule.start_date
json.lock_question capsule.lock_question
json.lock_answer capsule.lock_answer
json.recipients capsule.cached_recipients do |recipient|
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
json.is_liked capsule.liked_by?(current_user)
json.likes_count capsule.likes_count
#json.comments_count capsule.comments_count
json.comments_count capsule.test_comments_count
json.comments capsule.test_comments do |comment|
  json.id comment[:id]
  json.body comment[:body]
  json.set! :author do
    json.id comment[:author_id]
    json.full_name comment[:full_name]
    json.profile_image comment[:profile_image]
  end
end
json.is_portable capsule.is_portable || false
json.is_processed capsule.is_processed?
json.created_at capsule.created_at
json.updated_at capsule.updated_at
