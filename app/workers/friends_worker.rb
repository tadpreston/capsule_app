class FriendsWorker
  include Sidekiq::Worker

  def perform(user_id)
    begin
      user = User.find user_id

      friends = eval(user.oauth["friends"])
      ids = friends.collect { |f| f["id"] }.sort
      User.where(uid: ids).find_each do |u|
        user.add_as_contact(u)
        u.add_as_contact(user)
        user.follow!(u)
        u.follow!(user)
      end
    rescue ActiveRecord::RecordNotFound
    end

  end
end
