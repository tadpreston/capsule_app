class AddUserIdToCapsuleForward < ActiveRecord::Migration
  def change
    add_reference :capsule_forwards, :user, index: true
  end
end
