class YadaSerializer < ActiveModel::Serializer
  attributes :id, :comment, :creator, :recipients, :location, :status
  attributes :thumbnail_path, :assets, :start_date, :lock_question, :lock_answer
  attributes :comments_count, :created_at, :updated_at

  def assets
    object.assets.map do |asset|
      AssetSerializer.new asset, root: false
    end
  end

  def creator
    CreatorSerializer.new object.user, root: false if object.user
  end

  def recipients
    object.recipients.map do |recipient|
      RecipientSerializer.new recipient, root: false
    end
  end
end

