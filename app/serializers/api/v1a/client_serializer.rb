module API
  module V1a
    class ClientSerializer < ActiveModel::Serializer
      attributes :id, :name, :created_at, :updated_at
    end
  end
end
