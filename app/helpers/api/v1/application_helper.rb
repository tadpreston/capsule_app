module API
  module V1
    module ApplicationHelper
      def envelope(json, status, errors = nil)
        json.status status.to_s.humanize
        json.set! :response do
          yield if block_given?
          json.errors errors if errors
        end
      end
    end
  end
end
