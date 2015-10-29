module API
  module V1a
    class TemplateSerializer < ActiveModel::Serializer
      attributes :id, :assets

      def assets
        object.assets.map do |asset|
          API::V1a::AssetSerializer.new asset, root: false
        end
      end
    end
  end
end

