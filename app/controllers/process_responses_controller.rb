class ProcessResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    job_id = transloadit_params[:assembly_id]
    asset = Asset.find_by(job_id: job_id)
    asset.update_attributes(complete: true, metadata: transloadit_params)

    s3 = AWS::S3.new(
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    source_bucket = s3.buckets[ENV['S3_BUCKET_UPLOAD']]
    source_bucket.objects.delete asset.resource.split('/')[-1]

    render nothing: true
  end

  private

    def transloadit_params
      params.required(:transloadit).permit!
    end
end
