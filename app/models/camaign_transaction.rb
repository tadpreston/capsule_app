# == Schema Information
#
# Table name: camaign_transactions
#
#  id         :integer          not null, primary key
#  capsule_id :integer
#  user_id    :integer
#  order_id   :string(255)
#  amount     :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

class CamaignTransaction < ActiveRecord::Base
  belongs_to :capsule
  belongs_to :user
end
