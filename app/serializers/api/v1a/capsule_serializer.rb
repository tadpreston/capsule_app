module API
  module V1a
    class CapsuleSerializer < ActiveModel::Serializer
      delegate :current_user, to: :scope

      attributes :id, :comment, :creator, :recipients, :location, :status
      attributes :thumbnail_path, :assets, :start_date, :lock_question, :lock_answer
      attributes :comments_count, :is_read, :is_unlocked, :forwarded?, :campaign_id, :created_at, :updated_at

      def assets
        object.assets.map do |asset|
          API::V1a::AssetSerializer.new asset, root: false
        end
      end

      def creator
        API::V1a::CreatorSerializer.new object.user, root: false if object.user
      end

      def recipients
        object.recipients.map do |recipient|
          API::V1a::RecipientSerializer.new recipient, root: false
        end
      end

      def is_read
        object.read_by? current_user
      end

      def is_unlocked
        object.is_unlocked? current_user
      end
    end
  end
end
