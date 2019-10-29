class UpdateProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :cost, :float, null: :false
    add_index :products, :name, unique: :true
  end
end
