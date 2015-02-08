class YadaPoint
  attr_accessor :yada, :distance

  def initialize yada, point
    @yada = yada
    @point = point
    @distance = find_distance
  end

  private

  def find_distance
    yada_point = Vincenty.new yada.latitude, yada.longitude
    @point.distanceAndAngle(yada_point).distance
  end
end
