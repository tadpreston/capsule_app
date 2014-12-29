class Notifications::NewYadaNotification < Notifications::Base
  def process
    create_notification message
  end

  def message
   "You have received a Yada from #{@capsule.user_full_name}"
  end
end
