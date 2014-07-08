module API
  module V1
    class NoCacheCapsuleSerializer < ActiveModel::Serializer
      attributes :watched_by, :is_read, :is_owned
      delegate :current_user, to: :scope

      def watched_by
        object.watched_by? scope
      end

      def is_read
        object.read_by? scope
      end

      def is_owned
        Rails.logger.debug "<<<<<< #{current_user.inspect} >>>>>"
        if scope
          object.user_id == scope.id
        else
          false
        end
      end
    end
  end
end
