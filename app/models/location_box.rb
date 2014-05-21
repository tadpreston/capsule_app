# == Schema Information
#
# Table name: location_boxes
#
#  id            :integer          not null, primary key
#  latitude      :decimal(, )
#  longitude     :decimal(, )
#  lat_median    :decimal(, )
#  long_median   :decimal(, )
#  capsule_store :hstore           default({"ids"=>"[]"})
#  created_at    :datetime
#  updated_at    :datetime
#

class LocationBox < ActiveRecord::Base
  BOX_SIZE = 0.1

  def self.get_origin(latitude, longitude)
    origin_lat = latitude.round(2) > latitude.round(1) ? (latitude.round(1) + BOX_SIZE).round(1) : latitude.round(1)
    origin_long = longitude.round(2) < longitude.round(1) ? (longitude.round(1) - BOX_SIZE).round(1) : longitude.round(1)

    { latitude: origin_lat, longitude: origin_long }
  end

  def capsules
    Capsule.find ids
  end

  def capsule_count
    ids.size
  end

  def capsule_ids
    ids
  end

  protected

    def ids
      @ids || eval(capsule_store["ids"])
    end
end
