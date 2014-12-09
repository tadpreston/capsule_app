class AssetSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :media_type, :resource_path, :created_at, :updated_at

  def resource_path
    object.resource_path
  end
end
