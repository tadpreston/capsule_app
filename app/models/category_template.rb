class CategoryTemplate < ActiveRecord::Base
  belongs_to :category
  belongs_to :template
end
