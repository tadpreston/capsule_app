class Location
  attr_accessor :point, :user

  def initialize latitude, longitude, user
    @point = Vincenty.new latitude, longitude
    @user = user
  end

  def find
    Rails.cache.fetch "location_find_#{user.cache_key}_#{point.latitude.to_s}_#{point.longitude.to_s}", expire: 15.minutes do
      sorted_capsules = capsules.map { |yada| YadaPoint.new(yada, point) }.sort { |yada_point1,yada_point2| yada_point1.distance <=> yada_point2.distance }
      sorted_capsules.map(&:yada)
    end
  end

  private

  def capsules
    @capsules ||= user.capsules.location + user.received_capsules.location
  end
end
