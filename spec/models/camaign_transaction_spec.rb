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

require 'spec_helper'

describe CamaignTransaction do
  pending "add some examples to (or delete) #{__FILE__}"
end
