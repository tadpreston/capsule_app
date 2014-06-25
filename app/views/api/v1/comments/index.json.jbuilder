envelope(json, :success) do
  json.set! :comments do
    json.array! @comments do |comment|
#      json.partial! 'api/v1/comments/comment', comment: comment
      json.id comment.id
      json.body comment.body
      json.set! :author do
        json.id comment.user_id
        json.full_name comment.user.full_name
        json.profile_image comment.user.profile_image
      end
    end
  end
end
