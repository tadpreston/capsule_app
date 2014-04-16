envelope(json, :created) do
  json.comment do
    json.id @comment.id
    json.user_id @comment.user_id
    json.capsule_id @comment.capsule_id
    json.body @comment.body
  end
end
