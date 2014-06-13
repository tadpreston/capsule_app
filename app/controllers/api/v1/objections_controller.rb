module API
  module V1

    class ObjectionsController < API::V1::ApplicationController
      def create
        capsule = Capsule.find params[:capsule_id]
        if objection_params[:capsule_id]
          objectionable = capsule
        else
          objectionable = capsule.comments.find objection_params[:comment_id]
        end
        objectionable.objections.create(objection_params.merge({user_id: current_user.id}))
        render json: { status: 'Success' }
      end

      private

        def objection_params
          params.required(:objection).permit(:comment, :capsule_id, :comment_id)
        end
    end

  end
end
