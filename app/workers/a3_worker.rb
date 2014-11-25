class A3Worker

  def perform(capsule_id)
    capsule = Capsule.unscoped.find capsule_id

    unless capsule.thumbnail.blank?
      s3 = AWS::S3.new(
        access_key_id: ENV['AWS_ACCESS_KEY'],
        secret_access_key: ENV['AWS_SECRET_KEY']
      )

      source_bucket = s3.buckets[ENV['S3_BUCKET_UPLOAD']]

      if source_bucket.objects[capsule.thumbnail].exists?
        storage_path = "#{SecureRandom.urlsafe_base64(32)}/#{capsule.thumbnail}"
        dest_bucket = s3.buckets[ENV['S3_BUCKET']]
        source_obj = source_bucket.objects[capsule.thumbnail]
        dest_obj = dest_bucket.objects[storage_path]

        source_obj.copy_to(dest_obj, { acl: :public_read })
        source_bucket.objects.delete("#{capsule.thumbnail}")
        capsule.update_attributes(thumbnail: storage_path)
      else
        A3Worker.perform_in(15.seconds, capsule_id)
      end
    end
  end
end
