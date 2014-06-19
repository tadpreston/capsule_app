class Explorer
  BOX_THRESHOLD = 0.4
  BOX_SPAN_LARGE = 0.5
  BOX_SPAN_SMALL = 0.2

  def initialize(origin, span, hashtag = nil)
    @origin = origin
    @span = span
    @hashtag = hashtag
    @use_boxes = span[:lat] > BOX_THRESHOLD ? true : false
    @box_span = @span[:lat].to_f >= 2 ? 0.5 : 0.2 if @use_boxes

    @geo_range = geo_range
    @start_lat = @geo_range[:start_lat]
    @end_lat = @geo_range[:end_lat]
    @start_long = @geo_range[:start_long]
    @end_long = @geo_range[:end_long]

  end

  def find_capsules
    @capsule_boxes = Capsule.find_by_sql capsule_sql
    to_hash
  end

  def to_hash
    if @capsule_boxes.size > 0
      if @capsule_boxes[0].respond_to? :title
        { capsules: @capsule_boxes }
      else
        { capsules: single_capsules(@capsule_boxes), boxes: without_singles(@capsule_boxes) }
      end
    else
      { capsules: [] }
    end
  end

  def single_capsules(capsule_boxes_array)
    singles = capsule_boxes_array.clone
    singles.delete_if { |box| box.count > 1 }
    singles.map do |box|
      Rails.cache.fetch(["single/capsule/#{box.lat},#{box.lon}"]) do
        Capsule.where(latitude: box.lat.to_f..box.lat.to_f+@box_span, longitude: box.lon.to_f-@box_span..box.lon.to_f).take
      end
    end
  end

  def without_singles(capsule_boxes_array)
    boxes = capsule_boxes_array.clone.delete_if { |box| box.count == 1 }
    boxes.map { |bc| { name: "#{bc.lat},#{bc.lon}", center_lat: bc.med_lat, center_long: bc.med_long, count: bc.count } }
  end

  def geo_range
    if @use_boxes
      start_lat = (truncate_decimals((@origin[:lat] - @span[:lat]) / @box_span, 0) * @box_span).round(1)
      end_lat = (truncate_decimals(@origin[:lat].to_f / @box_span, 0) * @box_span).round(1)
      start_long = (truncate_decimals(@origin[:long].to_f / @box_span, 0) * @box_span) - @box_span
      end_long = truncate_decimals((@origin[:long].to_f + @span[:long].to_f) / @box_span, 0) * @box_span
    else
      start_lat = truncate_decimals(@origin[:lat].to_f - @span[:lat].to_f)
      end_lat = truncate_decimals(@origin[:lat].to_f) + 0.1
      start_long = truncate_decimals(@origin[:long].to_f) - 0.1
      end_long = truncate_decimals(@origin[:long].to_f + @span[:long].to_f)
    end
    { start_lat: start_lat, start_long: start_long, end_lat: end_lat, end_long: end_long }
  end

  def truncate_decimals(value, places = 1)
    precision = 10**places
    (value * precision).to_i / precision.to_f
  end

  def capsule_sql
    if @use_boxes
      if @hashtag.blank?
        sql = <<-SQL
          SELECT (trunc(latitude / #{@box_span}) * #{@box_span}) as lat, (trunc(longitude / #{@box_span}) * #{@box_span}) as lon, median(latitude) as med_lat, median(longitude) as med_long, count(*)
          FROM capsules
          WHERE (latitude BETWEEN #{@start_lat} AND #{@end_lat}) AND (longitude BETWEEN #{@start_long} AND #{@end_long}) AND (incognito = FALSE)
          GROUP BY lat, lon
          ORDER BY lat,lon;
        SQL
      else
        sql = <<-SQL
          SELECT (trunc(latitude / #{@box_span}) * #{@box_span}) as lat, (trunc(longitude / #{@box_span}) * #{@box_span}) as lon, median(latitude) as med_lat, median(longitude) as med_long, count(*)
          FROM capsules
          WHERE (latitude BETWEEN #{@start_lat} AND #{@end_lat}) AND (longitude BETWEEN #{@start_long} AND #{@end_long}) AND (title ilike '%#{@hashtag}%') AND (incognito = FALSE)
          GROUP BY lat, lon
          ORDER BY lat,lon;
        SQL
      end
    else
      sql = <<-SQL
        SELECT *
        FROM capsules
        WHERE (trunc(latitude,1) BETWEEN #{@start_lat} AND #{@end_lat}) AND (trunc(longitude,1) BETWEEN #{@start_long} AND #{@end_long}) AND (incognito = FALSE)
      SQL

      sql += " AND (title ilike '%#{@hashtag}%')" unless @hashtag.blank?
    end
    sql
  end
end
