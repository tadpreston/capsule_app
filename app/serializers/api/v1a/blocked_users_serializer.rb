module API
  module V1a
    class BlockedUsersSerializer < ActiveModel::Serializer
      attributes :full_name, :phone_number
    end
  end
end
