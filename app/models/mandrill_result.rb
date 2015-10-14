# == Schema Information
#
# Table name: mandrill_results
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  status     :string(255)
#  message_id :string(255)
#  reason     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MandrillResult < ActiveRecord::Base
end
