# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_by :integer
#  updated_by :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Client do
  pending "add some examples to (or delete) #{__FILE__}"
end
