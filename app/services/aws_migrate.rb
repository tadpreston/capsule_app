class AwsMigrate
  attr_accessor :source_s3, :target_s3

  EAST_BUCKET = 'capsule-app-upload'
  WEST_BUCKET = 'pinyada'

  def initialize
    @source_s3 = Aws::S3::Client.new region: 'us-east-1', access_key_id: ENV['AWS_ACCESS_KEY_ID_EAST'],
                                     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_EAST']
    @target_s3 = Aws::S3::Client.new region: 'us-west-2', access_key_id: ENV['AWS_ACCESS_KEY_ID_WEST'],
                                     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_WEST']
  end

  def transfer
    get_objects
    put_objects
  end

  def get_objects
    puts "Getting the objects -----------------------------"
    object_keys.each do |key|
      begin
        file_path = Rails.root.join('tmp','migration',key)
        FileUtils.mkdir_p Rails.root.join('tmp','migration',key.split('/').first) if key.split('/').count == 2
        source_s3.get_object bucket: EAST_BUCKET, response_target: file_path, key: key
      rescue Exception => e
        puts "Key: #{key} -- #{e}"
      end
    end
  end

  def put_objects
    puts "Putting the objects -----------------------------"
    object_keys.each do |key|
      begin
        object = Aws::S3::Object.new WEST_BUCKET, key, client: target_s3
        object.upload_file Rails.root.join('tmp','migration',key).to_s unless object.exists?
      rescue Exception => e
        puts "Key: #{key} -- #{e}"
      end
    end
  end

  def delete_target_objects
    object_keys.each do |key|
      begin
        target_s3.delete_object bucket: WEST_BUCKET, key: key, acl: "public-read|bucket-owner-full-control"
      rescue Exception => e
        puts "Key: #{key} -- #{e}"
      end
    end
  end

  def object_keys
    @object_keys ||= source_s3.list_objects(bucket: EAST_BUCKET).inject([]) do |memo, result|
      memo + result.contents.map(&:key)
    end
  end
end
