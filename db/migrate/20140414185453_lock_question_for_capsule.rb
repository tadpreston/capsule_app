class LockQuestionForCapsule < ActiveRecord::Migration
  def up
    remove_column :capsules, :passcode
    add_column    :capsules, :lock_question, :string
    add_column    :capsules, :lock_answer, :string
  end

  def down
    add_column    :capsules, :passcode, :string
    remove_column :capsules, :lock_question
    remove_column :capsules, :lock_answer
  end
end
