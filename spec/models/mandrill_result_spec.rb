# == Schema Information
#
# Table name: mandrill_results
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :string(255)
#  message_id :string(255)
#  reason     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe MandrillResult do
  pending "add some examples to (or delete) #{__FILE__}"
end
