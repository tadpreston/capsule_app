module Location

  class GeoBox
    attr_reader :range

    def initialize(latitude, longitude, span_lat, span_long = nil)
      @latitude = latitude
      @longitude = longitude
      @span_lat = span_lat
      @span_long = span_long

      if span_long
        box_by_span
      else
        @radius = span_lat
        box_by_radius
      end
    end

    def to_where
      where_clause = []
      where_clause << "(latitude BETWEEN #{@range[:south_lat]} AND #{@range[:north_lat]})"
      if @range[:west_long].is_a? Float
        where_clause << "(longitude BETWEEN #{@range[:west_long]} AND #{@range[:east_long]})"
      else
        where_clause << "(longitude BETWEEN #{@range[:west_long][0]} AND #{@range[:west_long][1]} OR longitude BETWEEN #{@range[:east_long][0]} AND #{@range[:east_long][1]})"
      end
      where_clause.join(' AND ')
    end

    private

      def box_by_span
        # Assumption: given lat and long are the top left of the box
        north_lat = @latitude
        south_lat = @latitude - @span_lat
        south_lat = -90 if south_lat < -90
        west_long = @longitude
        east_long = @longitude + @span_long
        if east_long > 180
          west_long = [@longitude, 180]
          east_long = [-180, (east_long - 360)]
        end
        @range = { north_lat: north_lat, south_lat: south_lat, west_long: west_long, east_long: east_long }
      end

      def box_by_radius
        # Assumption: given lat and long are the center of the box
        @span_lat = @radius * 2
        @span_long = @radius * 2

        @latitude = @latitude + @radius
        @latitude = 90 if @latitude > 90
        @longitude = @longitude - @radius
        @longitude = @longitude + 360 if @longitude < -180

        box_by_span
      end

  end

end
