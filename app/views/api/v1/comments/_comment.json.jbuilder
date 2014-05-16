json.id comment.id
json.body comment.body
json.set! :author do
  json.partial! 'api/v1/users/user', user: comment.user
end
json.set! :replies do
  json.array! comment.replies do |reply|
    json.partial! 'api/v1/comments/comment', comment: reply
  end
end
json.is_liked comment.liked_by?(current_user)
json.likes_count comment.likes_count
json.created_at comment.created_at
json.updated_at comment.updated_at
