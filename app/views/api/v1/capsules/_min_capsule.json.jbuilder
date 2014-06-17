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
