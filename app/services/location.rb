class Location
  attr_accessor :point, :user

  def initialize latitude, longitude, user
    @point = Vincenty.new latitude, longitude
    @user = user
  end

  def find params = {}
    offset = params.fetch(:offset, 0).to_i
    limit = params.fetch(:limit, 0).to_i
    sorted_capsules = capsules.map { |yada| YadaPoint.new(yada, point) }.sort { |yada_point1,yada_point2| yada_point1.distance <=> yada_point2.distance }
    sorted_capsules.map(&:yada)[offset..(offset+limit-1)]
  end

  private

  def capsules
    @capsules ||= user.capsules.location + user.received_capsules.location
  end
end
