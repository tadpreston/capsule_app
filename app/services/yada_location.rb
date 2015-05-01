class YadaLocation

  def locations
    @locations ||= Capsule.location.map do |capsule|
      {
        name: capsule.location["name"],
        latitude: capsule.location["latitude"],
        longitude: capsule.location["longitude"]
      }
    end
  end

  def locations_count
    locations.count
  end

  def time_yada_count
    @time_yada_count ||= Capsule.where(location: nil).count
  end

  def yada_count
    @yada_count ||= Capsule.count
  end
end
