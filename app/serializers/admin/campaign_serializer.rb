module Admin
  class CampaignSerializer < ActiveModel::Serializer
    attributes *(Campaign::ATTRIBUTES)
  end
end
