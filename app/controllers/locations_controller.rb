class LocationsController < ApplicationController
  def map
    @locations = Capsule.location.map { |cap| {name: cap.location["name"], latitude: cap.location["latitude"], longitude: cap.location["longitude"]} }
    @timeYadaCount = Capsule.where(location: nil).count
    @totalYadaCount = Capsule.count
  end
end
