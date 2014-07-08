module Location
  class GeoPoint
    def initialize(origin, max_distance = 48280.32)
      @origin = origin
      @max_distance = max_distance
      @bearing = 360
    end

    # generates a single random point from a given origin at a max distance in meters. Default max distance is 30 miles.
    def get_point()
      bearing = rand(@bearing)
      distance = rand(@max_distance)
      Vincenty.destination(@origin[:lat], @origin[:long], bearing, distance)
    end

    # generates random points from a given origin at a max distance in meters. Default max distance is 30 miles
    def get_points(count = 1)
      points = []
      count.times do
        points << get_point
      end

      points
    end
  end
end
