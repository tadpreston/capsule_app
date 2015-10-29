class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :description

      t.timestamps
    end
  end
end
