class CapsuleForwarder
  attr_reader :recipients, :user_id, :capsule_id

  def initialize params
    @recipients = params[:recipients]
    @user_id = params[:user_id]
    @capsule_id = params[:id]
  end

  def self.forward params
    new(params).forward
  end

  def forward
    recipients.map do |recipient|
      create_capsule_from_original recipient
    end
  end

  private

  def capsule
    @capsule ||= Capsule.find capsule_id
  end

  def create_capsule_from_original recipient
    new_capsule = initialize_from_original recipient
    copy_assets new_capsule
    new_capsule
  end

  def initialize_from_original recipient
    new_capsule = capsule.dup
    new_capsule.user_id = user_id
    new_capsule.recipients_attributes = [recipient]
    new_capsule.forwarded = true
    new_capsule.save
    new_capsule
  end

  def copy_assets new_capsule
    capsule.assets.each { |asset| new_capsule.assets.create media_type: asset.media_type, resource: asset.resource }
  end
end
