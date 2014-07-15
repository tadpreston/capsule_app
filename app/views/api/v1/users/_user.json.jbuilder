json.user do
  json.id user.id
  json.email user.email
  json.username user.username
  json.motto user.motto || ''
  json.facebook_username user.facebook_username || ''
  json.twitter_username user.twitter_username || ''
  json.full_name user.full_name
  json.first_name user.first_name
  json.last_name user.last_name
  json.phone_number user.phone_number || ''
  json.location user.location
  json.locale user.locale
  json.timezone user.time_zone || ''
  json.provider user.provider || ''
  json.uid user.uid || ''
  json.profile_image user.profile_image_path
  json.background_image user.background_image_path
  json.tutorial_progress user.tutorial_progress
  json.settings user.settings
  json.email_confirmed (user.confirmed? ? true : false)
  json.watching_count user.watching_count
  json.watchers_count user.watchers_count
  json.is_watched current_user ? current_user.is_following?(user) : false
  json.created_at user.created_at
  json.updated_at user.updated_at
end
