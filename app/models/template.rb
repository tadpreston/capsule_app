# == Schema Information
#
# Table name: templates
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Template < ActiveRecord::Base
  has_many :assets, as: :assetable, dependent: :destroy
end
