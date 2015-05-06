module API
  module V1a
    class RelationshipsController < API::V1a::ApplicationController

      def create
        @follow_user = User.find(params[:relationship][:follow_id])
        current_user.follow!(@follow_user)
      end

      def destroy
        @follow_user = User.find(params[:id])
        current_user.unfollow!(@follow_user)
        render json: { status: 'Success' }
      end
    end
  end
end
