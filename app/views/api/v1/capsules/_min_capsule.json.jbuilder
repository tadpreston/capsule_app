json.id capsule.id
json.title capsule.title
json.set! :hash_tags, capsule.hash_tags.split(' ')
json.location capsule.location
json.relative_location capsule.relative_location
json.thumbnail capsule.thumbnail_path
json.is_watched capsule.watched_by?(current_user)
json.is_incognito capsule.incognito || false
json.is_read capsule.read_by?(current_user)
json.is_portable capsule.is_portable || false
json.is_owned is_owned?(capsule.user_id)
json.is_processed capsule.is_processed?
json.comments_count capsule.comments_count
json.set! :creator do
  json.id capsule.cached_user.id
  json.full_name capsule.cached_user.full_name
  json.profile_image capsule.cached_user.profile_image
end
