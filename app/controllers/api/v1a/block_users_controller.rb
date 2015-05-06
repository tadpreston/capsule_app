module API
  module V1a
    class BlockUsersController < API::V1a::ApplicationController
      before_action :set_user_block

      def index
        render json: @user_block.blocked_users, each_serializer: BlockedUsersSerializer
      end

      def create
        @user_block.block_user block_user_params[:phone_number]
        render json: { status: 'User Blocked' }
      rescue ActiveRecord::RecordNotFound
        render json: resource_not_found_response(:block_user, block_user_params[:phone_number]), status: 404
      end

      def destroy
        @user_block.remove_block params[:id]
        render json: { status: 'User Block Removed' }
      rescue ActiveRecord::RecordNotFound
        render json: resource_not_found_response(:unblock_user, params[:id]), status: 404
      end

      private

      def block_user_params
        params.require(:user).permit(:phone_number)
      end

      def set_user_block
        @user_block = User::Blocker.find current_user.id
      end
    end
  end
end
