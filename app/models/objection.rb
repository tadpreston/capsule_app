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
#  obscene            :boolean
#

class Objection < ActiveRecord::Base
  belongs_to :objectionable, polymorphic: true
  belongs_to :user
  belongs_to :admin_user

  def is_dmca=(value)
    self.dmca = value
  end

  def is_dmca
    self.dmca
  end

  def is_criminal=(value)
    self.criminal = value
  end

  def is_criminal
    self.criminal
  end

  def is_obscene=(value)
    self.obscene = value
  end

  def is_obscene
    self.obscene
  end
end
