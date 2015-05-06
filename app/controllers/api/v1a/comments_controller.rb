module API
  module V1a
    class CommentsController < API::V1a::ApplicationController
      before_action :set_capsule
      before_action :set_comment, only: [:like, :unlike]
      skip_before_action :authorize_auth_token, only: :index

      def index
        @comments = @capsule.comments
        render json: @comments, each_serializer: CommentSerializer
      end

      def create
        @comment = @capsule.comments.create(comment_params.merge({user_id: current_user.id}))
        render json: @comment
      end

      def destroy
        comment = @capsule.comments.find(params[:id])
        comment.destroy
        render json: { status: 'Deleted' }
      end

      def like
        @comment.likes << current_user.id
        @comment.save
        render json: @comment
      end

      def unlike
        @comment.likes.delete current_user.id
        @comment.save
        render json: @comment
      end

      private

        def set_capsule
          begin
            @capsule = Capsule.find params[:capsule_id]
          rescue
            render json: { status: 'Not Found', response: { errors: [ { capsule: [ "Not found with id: #{params[:capsule_id]}" ] } ] } }, status: 404
          end
        end

        def set_comment
          begin
            @comment = Comment.find params[:id]
          rescue
            render json: { status: 'Not Found', response: { errors: [ { comment: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
          end
        end

        def comment_params
          params.required(:comment).permit(:body)
        end
    end

  end
end
