class ProcessResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    job_id = params[:assembly_id]
    asset = Asset.find_by(job_id: job_id)
    asset.update_attributes(complete: true, metadata: params)

    render nothing: true
  end
end
