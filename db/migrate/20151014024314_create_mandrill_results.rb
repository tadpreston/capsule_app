class CreateMandrillResults < ActiveRecord::Migration
  def change
    create_table :mandrill_results do |t|
      t.references :user, index: true
      t.string :status
      t.string :message_id
      t.string :reason

      t.timestamps
    end
  end
end
