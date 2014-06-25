json.id comment.id
json.body comment.body
json.set! :author do
  json.id comment.user_id
  json.first_name comment.user_first_name
  json.last_name comment.user_last_name
  json.profile_image comment.user_profile_image
end
json.is_liked comment.liked_by?(current_user)
json.likes_count comment.likes_count
json.created_at comment.created_at
json.updated_at comment.updated_at
