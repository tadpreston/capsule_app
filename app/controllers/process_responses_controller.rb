class ProcessResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create

    Rails.logger.error "<<<<<<<<<<< #{params["transloadit"].inspect} >>>>>>>>>>>>>>>"

    transloadit = JSON.parse params["transloadit"]

    job_id = transloadit["assembly_id"]
    asset = Asset.find_by(job_id: job_id)
    asset.update_attributes(complete: true, metadata: transloadit)

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
      params.require(:transloadit).permit!
    end
end
