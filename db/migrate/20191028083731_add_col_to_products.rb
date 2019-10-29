class AddColToProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :category_id
    add_column :products, :category, :string, index: true, null: false

    drop_table :categories
  end
end
