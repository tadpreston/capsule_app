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

    @geo_box = Location::GeoBox.new(@origin[:lat], @origin[:long], @span[:lat], @span[:long])

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
        if box.lat.to_f < 0
          lat_end = box.lat.to_f
          lat_start = box.lat.to_f-@box_span
        else
          lat_start = box.lat.to_f
          lat_end = box.lat.to_f+@box_span
        end
        if box.lon.to_f < 0
          start_long = box.lon.to_f - @box_span
          end_long = box.lon.to_f
        else
          start_long = box.lon.to_f
          end_long = box.lon.to_f + @box_span
        end
        Capsule.where(latitude: lat_start..lat_end, longitude: start_long..end_long).take
#      Rails.cache.fetch(["single/capsule/#{box.lat},#{box.lon}"]) do
#      end
    end
  end

  def without_singles(capsule_boxes_array)
    boxes = capsule_boxes_array.clone.delete_if { |box| box.count == 1 }
    boxes.map { |bc| { name: "#{bc.lat},#{bc.lon}", center_lat: bc.med_lat, center_long: bc.med_long, count: bc.count } }
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
          WHERE #{@geo_box.to_where} AND (incognito = FALSE) AND (TRIM(status) IS NULL)
          GROUP BY lat, lon
          ORDER BY lat,lon;
        SQL
      else
        sql = <<-SQL
          SELECT (trunc(latitude / #{@box_span}) * #{@box_span}) as lat, (trunc(longitude / #{@box_span}) * #{@box_span}) as lon, median(latitude) as med_lat, median(longitude) as med_long, count(*)
          FROM capsules
          WHERE #{@geo_box.to_where} AND (title ilike '%#{@hashtag}%')
                AND (incognito = FALSE)
                AND (TRIM(status) IS NULL)
          GROUP BY lat, lon
          ORDER BY lat,lon;
        SQL
      end
    else
      sql = <<-SQL
        SELECT *
        FROM capsules
        WHERE #{@geo_box.to_where} AND (incognito = FALSE) AND (TRIM(status) IS NULL)
      SQL

      sql += " AND (title ilike '%#{@hashtag}%')" unless @hashtag.blank?
    end
    sql
  end
end
