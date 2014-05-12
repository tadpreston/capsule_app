module API
  module V1

    class LocationWatchesController < API::V1::ApplicationController

      def create
        @location_watch = current_user.location_watches.build(location_watch_params)
        unless @location_watch.save
          render :create, status: 422
        end
        render json: { status: 'Success' }
      end

      def destroy
        location_watch = LocationWatch.find(params[:id])
        location_watch.destroy
        render json: { status: 'Success' }
      end

      private

        def location_watch_params
          params.required(:location_watch).permit(:latitude, :longitude, :radius)
        end
    end
  end
end
