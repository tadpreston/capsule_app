class ProcessResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create

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

    if asset.media_type == 'profile' || asset.media_type == 'background'
      user = asset.assetable
      if asset.media_type == 'profile'
        user.update_attribute(:profile_image, asset.resource)
      else
        user.update_attribute(:background_image, asset.resource)
      end
    end

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
