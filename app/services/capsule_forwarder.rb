class CapsuleForwardError < StandardError; end
class CapsuleForwarder
  attr_reader :recipients, :user_id, :capsule_id
  attr_accessor :capsules, :links

  def initialize params
    @recipients = params[:recipients]
    @user_id = params[:user_id]
    @capsule_id = params[:id]
    @capsules = []
    @links = []
  end

  def self.forward params
    new(params).forward
  end

  def forward
    raise CapsuleForwardError if any_participated?
    recipients.each do |recipient|
      create_capsule_from_original recipient
    end
    self
  end

  private

  def capsule
    @capsule ||= Capsule.find capsule_id
  end

  def create_capsule_from_original recipient
    create_link recipient unless registered? recipient
    new_capsule = initialize_from_original recipient
    capsule.capsule_forwards.create forward_id: new_capsule.id
    copy_assets new_capsule
    capsules << new_capsule
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

  def registered? recipient
    User.find_by phone_number: recipient[:phone_number]
  end

  def create_link recipient
    links << recipient.merge(url: generate_url)
  end

  def generate_url
    "#{capsule.base_url}/#{capsule.token}"
  end

  def any_participated?
    CapsuleForward.find_by user_id: user_id
  end
end
