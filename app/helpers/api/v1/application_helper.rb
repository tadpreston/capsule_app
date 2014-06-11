module API
  module V1
    module ApplicationHelper

      def envelope(json, status, errors = nil)
        json.status status.to_s.humanize
        json.set! :response do
          yield if block_given?

          if errors
            json.errors errors do |key, value|
              json.set! key, value
            end
          end
        end

      end

      def is_owned?(user_id)
        if current_user
          user_id == current_user.id
        else
          false
        end
      end
    end
  end
end
