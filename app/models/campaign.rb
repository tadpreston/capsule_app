# == Schema Information
#
# Table name: campaigns
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  code        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  budget      :decimal(, )
#  base_url    :string(255)
#

class Campaign < ActiveRecord::Base
  has_many :capsules
  has_many :campaign_transactions

  def budget_room?
    spent < budget
  end

  def redeemed? user
    campaign_transactions.exists? user_id: user.id
  end

  private

  def spent
    campaign_transactions.map(&:amount).sum
  end
end
