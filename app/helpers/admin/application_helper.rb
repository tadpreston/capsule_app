module Admin
  module ApplicationHelper
    def authorized?
      current_user
    end
  end
end
