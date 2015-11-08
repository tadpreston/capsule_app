# == Schema Information
#
# Table name: relevances
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  capsule_id    :integer
#  relevant_date :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Relevance < ActiveRecord::Base
  belongs_to :user
  belongs_to :capsule

  def self.update_relevance capsule_id, *user_ids
    user_ids.each do |user_id|
      if relevance = find_by(capsule_id: capsule_id, user_id: user_id)
        relevance.update_attributes relevant_date: Time.current
      end
    end
  end

  def self.remove params
    relevance = Relevance.find_by params
    relevance.destroy
  end

  def self.remove_feed_for user_id, yada_ids
    where(capsule_id: yada_ids, user_id: user_id).destroy_all
  end

  def self.restore_feed_for user_id, yada_ids
    yada_ids.each { |capsule_id| create capsule_id: capsule_id, user_id: user_id, relevant_date: Time.current }
  end
end
