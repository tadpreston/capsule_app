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
end
