module API
  module V1

    class RelationshipsController < API::V1::ApplicationController

      def create
        @follow_user = User.find(params[:relationship][:follow_id])
        current_user.follow!(@follow_user)
      end

      def destroy
        @follow_user = User.find(params[:id])
        current_user.unfollow!(@follow_user)
      end
    end
  end
end
