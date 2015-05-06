module API
  module V1a
    module ApplicationHelper

      def envelope(json, status, errors = nil, alert = true)
        json.status status.to_s.humanize
        json.set! :response do
          if alert
            json.set! :alert do
              json.text 'Test alert text body'
              json.title 'Test alert title'
              json.action_url 'capsule://actionUrl'
              json.action_title 'Take Action'
              json.cancel_url 'capsule://cancelUrl'
              json.cancel_title 'Cancel'
            end
          end
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
