module API
  module V1

    class ObjectionsController < API::V1::ApplicationController
      def create
        if params[:capsule_id]
          objectionable = Capsule.find params[:capsule_id]
        elsif params[:comment_id]
          objectionable = Comment.find params[:comment_id]
        else
          render json: { status: 'Unknown entity' }
        end
        objectionable.objections.create(objection_params.merge({user_id: current_user.id}))
        render json: { status: 'Success' }
      end

      private

        def objection_params
          params.required(:objection).permit(:comment, :is_dmca, :is_criminal, :is_obscene)
        end
    end

  end
end
