module API
  module V1a
    class AssetSerializer < ActiveModel::Serializer
      attributes :id, :media_type, :resource_path, :resource, :created_at, :updated_at

      def resource_path
        object.signed_resource_path
      end
    end
  end
end
