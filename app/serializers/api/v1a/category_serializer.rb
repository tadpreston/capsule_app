module API
  module V1a
    class CategorySerializer < ActiveModel::Serializer
      attributes :id, :name, :templates, :created_at, :updated_at

      def templates
        object.templates.map do |asset|
          API::V1a::TemplateSerializer.new asset, root: false
        end
      end
    end
  end
end
