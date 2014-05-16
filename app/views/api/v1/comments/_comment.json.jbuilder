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
json.created_at comment.created_at
json.updated_at comment.updated_at
