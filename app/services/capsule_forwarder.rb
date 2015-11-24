class CapsuleForwardError < StandardError; end
class CapsuleAlreadyForwardedError < StandardError; end
class CapsuleForwarder
  attr_reader :recipients, :user_id, :capsule_id, :start_date
  attr_accessor :capsules, :links

  FORWARD_IMAGE = 'assets/forwarded/CoffeeYadaImages_Forwarded.png'
  FORWARD_COMMENT = 'So I chose to pin it to you! You can keep the coffee or pin-it-forward to two others and make their day. Whatever you choose know you’re appreciated.'

  def initialize params
    @recipients = params[:recipients]
    @user_id = params[:user_id]
    @capsule_id = params[:id]
    @start_date = params[:start_date]
    @capsules = []
    @links = []
  end

  def self.forward params
    new(params).forward
  end

  def forward
    raise CapsuleAlreadyForwardedError, 'Yada has already been forwarded' if capsule.forwarded?
    raise CapsuleForwardError, error_description if any_participated?
    recipients.each { |recipient| create_capsule_from_original recipient }
    capsule.update_attributes forwarded: true
    self
  end

  private

  def capsule
    @capsule ||= Capsule.find capsule_id
  end

  def create_capsule_from_original recipient
    create_link recipient unless registered? recipient
    new_capsule = initialize_capsule recipient
    create_assets new_capsule
    capsule.capsule_forwards.create forward_id: new_capsule.id, user_id: new_capsule.recipients.first.id
    capsules << new_capsule
  end

  def initialize_capsule recipient
    new_capsule = Capsule.create user_id: user_id, recipients_attributes: [recipient], start_date: Time.current,
                  comment: FORWARD_COMMENT, payload_type: '1', campaign_id: capsule.campaign_id
    new_capsule
  end

  def create_assets new_capsule
    new_capsule.assets.create media_type: '1', resource: FORWARD_IMAGE
  end

  def registered? recipient
    User.find_by phone_number: recipient[:phone_number]
  end

  def create_link recipient
    links << ForwardLink.new(email: recipient[:email], phone_number: recipient[:phone_number], url: generate_url)
  end

  def generate_url
    "#{capsule.base_url}/#{capsule.token}"
  end

  def any_participated?
    !participants.empty?
  end

  def recipient_ids
    recipients.map { |recipient| User.find_by(phone_number: recipient[:phone_number]) }.compact.map(&:id)
  end

  def participants
    CapsuleForward.where user_id: recipient_ids
  end

  def error_description
    participant_phone_numbers.join(",")
  end

  def participant_phone_numbers
    [participants].flatten.map { |p| p.user.phone_number }
  end
end
