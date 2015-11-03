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

require 'spec_helper'

describe CampaignTransaction do
  pending "add some examples to (or delete) #{__FILE__}"
end
