class LocationsController < ApplicationController
  def map
    @yada_location = YadaLocation.new
  end
end
