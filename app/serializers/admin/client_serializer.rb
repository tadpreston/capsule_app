module Admin
  class ClientSerializer < ActiveModel::Serializer
    attributes :id, :name, :email, :profile_image
  end
end
