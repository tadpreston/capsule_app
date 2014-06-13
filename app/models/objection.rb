# == Schema Information
#
# Table name: objections
#
#  id                 :integer          not null, primary key
#  objectionable_id   :integer
#  objectionable_type :string(255)
#  user_id            :integer
#  comment            :text
#  dmca               :boolean
#  criminal           :boolean
#  admin_user_id      :integer
#  handled_at         :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class Objection < ActiveRecord::Base
  belongs_to :objectionable, polymorphic: true
  belongs_to :user
  belongs_to :admin_user
end
