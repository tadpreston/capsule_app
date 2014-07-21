json.id capsule.id
json.title capsule.title
json.set! :hash_tags, capsule.hash_tags_array
json.location capsule.location
json.relative_location capsule.relative_location
json.thumbnail capsule.thumbnail_path
json.is_incognito capsule.incognito || false
json.is_portable capsule.is_portable || false
json.is_processed capsule.is_processed?
json.comments_count capsule.comments_count
json.set! :creator do
  json.id capsule.cached_user.id
  json.first_name capsule.cached_user.first_name
  json.last_name capsule.cached_user.last_name
  json.profile_image capsule.cached_user.profile_image_path
end
