class LocationsController < ApplicationController
  def map
    @locations = Capsule.location.map { |cap| {name: cap.location["name"], latitude: cap.location["latitude"], longitude: cap.location["longitude"]} }
  end
end
