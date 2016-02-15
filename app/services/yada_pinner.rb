class YadaPinner
  attr_accessor :client, :campaign, :unlock_at, :user_ids

  def initialize client, campaign, unlock_at, user_ids
    @client = client
    @campaign = campaign
    @unlock_at = unlock_at
    @user_ids = user_ids
  end

  def self.pinit(client:, campaign:, unlock_at:, user_ids:)
    new(client, campaign, unlock_at, user_ids).pinit
  end

  def pinit
    user_ids.map do |user_id|
      yada = Capsule.new start_date: unlock_at, user_id: client.user_id, campaign_id: campaign.id, payload_type: '1',
        comment: campaign.client_message
      create_associations yada, user_id
      yada
    end
  end

  private

  def create_associations yada, user_id
    create_and_associate_asset yada
    associate_recipient yada, user_id
    create_forward yada
  end

  def create_and_associate_asset yada
    yada.assets.create media_type: '1', resource: campaign.image_from_client
  end

  def associate_recipient yada, user_id
    yada.recipient_users.create user_id: user_id
  end

  def create_forward yada
    CapsuleForward.create capsule_id: yada.id, user_id: campaign.user_id
  end
end
