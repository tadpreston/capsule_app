class WatchedLocationSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :latitude, :longitude, :radius, :created_at, :updated_at
end
