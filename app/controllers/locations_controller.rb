class LocationsController < ApplicationController
	def map
		@locations = Capsule.where("location IS NOT NULL").map { |cap| {name: cap.location["name"], latitude: cap.location["latitude"], longitude: cap.location["longitude"]} }
	end
end