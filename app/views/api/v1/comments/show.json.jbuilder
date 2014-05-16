envelope(json, :created) do
  json.comment do
    json.partial! 'api/v1/comments/comment', comment: @comment
  end
end
