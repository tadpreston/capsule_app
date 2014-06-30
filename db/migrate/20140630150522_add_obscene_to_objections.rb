class AddObsceneToObjections < ActiveRecord::Migration
  def change
    add_column :objections, :obscene, :boolean
  end
end
