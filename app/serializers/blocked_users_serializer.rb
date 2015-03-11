class BlockedUsersSerializer < ActiveModel::Serializer
  attributes :full_name, :phone_number
end
