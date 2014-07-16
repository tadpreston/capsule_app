class ProcessResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create

    transloadit = JSON.parse params["transloadit"]

    job_id = transloadit["assembly_id"]
    asset = Asset.find_by(job_id: job_id)
    asset.update_attributes(complete: true, metadata: transloadit)

    ProcessResponseWorker.perform_async asset.id

    render nothing: true
  end

  private

    def image_container(job_id)
      object = Asset.find_by(job_id: job_id)
      unless object
        object = User.find_by(job_id: job_id)
      end
      object
    end

    def transloadit_params
      params.require(:transloadit).permit!
    end
end
