class FeedUpdater
  attr_accessor :capsule_id, :user_id, :update_current_user

  def initialize capsule_id, user_id, update_current_user = false
    @capsule_id = capsule_id
    @user_id = user_id
    @update_current_user = update_current_user
  end

  def perform
    relevances.each do |relevance|
      if update_current_user || relevance.user_id != user_id
        relevance.update_attributes relevant_date: DateTime.now
      end
    end
  end

  private

  def relevances
    Relevance.where capsule_id: capsule_id
  end
end
