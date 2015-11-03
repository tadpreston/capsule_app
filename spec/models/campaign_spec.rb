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

require 'spec_helper'

describe Campaign do
  it { should have_many :capsules }
end
