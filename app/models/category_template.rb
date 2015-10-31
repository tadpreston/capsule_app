# == Schema Information
#
# Table name: category_templates
#
#  id          :integer          not null, primary key
#  category_id :integer
#  template_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class CategoryTemplate < ActiveRecord::Base
  belongs_to :category
  belongs_to :template
end
