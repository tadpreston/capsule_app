module Admin
  class YadaSerializer < ActiveModel::Serializer
    attributes :id, :comment, :creator, :recipients, :thumbnail_path, :assets

    def creator
      API::V1a::CreatorSerializer.new object.user, root: false if object.user
    end

    def recipients
      object.recipients.map do |recipient|
        API::V1a::RecipientSerializer.new recipient, root: false
      end
    end

    def assets
      object.assets.map do |asset|
        API::V1a::AssetSerializer.new asset, root: false
      end
    end
  end
end
