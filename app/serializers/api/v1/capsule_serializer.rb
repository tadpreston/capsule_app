module API
  module V1
    class CapsuleSerializer < ActiveModel::Serializer
      cached
      delegate :cache_key, to: :object

      attributes :id, :in_reply_to, :title, :location, :relative_location, :payload_type, :status, :promotional_state
      attributes :thumbnail_path, :start_date, :lock_question, :lock_answer
      attributes :likes_count, :comments_count, :created_at, :updated_at

      has_many :comments
    end
  end
end
