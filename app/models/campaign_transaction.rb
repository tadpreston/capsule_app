# == Schema Information
#
# Table name: campaign_transactions
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  capsule_id  :integer
#  user_id     :integer
#  order_id    :string(255)
#  amount      :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#

class CampaignTransaction < ActiveRecord::Base
  belongs_to :capsule
  belongs_to :user
end
