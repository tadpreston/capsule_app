# == Schema Information
#
# Table name: campaigns
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  description       :text
#  code              :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  budget            :decimal(, )
#  base_url          :string(255)
#  client_id         :integer
#  client_message    :string(255)
#  user_message      :string(255)
#  image_from_client :string(255)
#  image_from_user   :string(255)
#  image_keep        :string(255)
#  image_forward     :string(255)
#  image_expired     :string(255)
#

class Campaign < ActiveRecord::Base
  ATTRIBUTES = [:id, :name, :budget, :client_id, :client_message, :user_message, :image_from_client, :image_from_user, :image_keep, :image_forward, :image_expired, :updated_at, :created_at]

  has_many :capsules
  has_many :campaign_transactions
  belongs_to :client

  def budget_room?
    spent < budget
  end

  def redeemed? user
    campaign_transactions.exists? user_id: user.id
  end

  private

  def spent
    campaign_transactions.sum 'amount'
  end
end
