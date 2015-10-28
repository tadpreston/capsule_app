class CreateCategoryTemplates < ActiveRecord::Migration
  def change
    create_table :category_templates do |t|
      t.integer :category_id
      t.integer :template_id

      t.timestamps
    end
  end
end
