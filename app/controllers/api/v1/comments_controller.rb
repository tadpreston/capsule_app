module API
  module V1

    class CommentsController < API::V1::ApplicationController
      before_action :set_capsule

      def create
        @comment = @capsule.comments.new(comment_params.merge({user_id: current_user.id}))
        @comment.save
      end

      def destroy
        @comment = @capsule.comments.find(params[:id])
        @comment.destroy
        render json: { status: 'Deleted' }
      end

      private

        def set_capsule
          begin
            @capsule = Capsule.find params[:capsule_id]
          rescue
            render json: { status: 'Not Found', response: { errors: [ { capsule: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
          end
        end

        def comment_params
          params.required(:comment).permit(:body)
        end
    end

  end
end
