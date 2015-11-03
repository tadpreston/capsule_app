#  id         :integer          not null, primary key
#  capsule_id :integer
#  user_id    :integer
#  order_id   :string(255)
#  amount     :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#


FactoryGirl.define do
  factory :campaign_transaction do
    amount 50.00
  end
end
