# == Schema Information
#
# Table name: campaigns
#
#  id          :integer          not null, primary key
#  capsule_id  :integer
#  name        :string(255)
#  description :text
#  code        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Campaign do
  pending "add some examples to (or delete) #{__FILE__}"
end
