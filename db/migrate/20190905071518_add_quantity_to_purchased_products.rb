class AddQuantityToPurchasedProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :purchased_products, :quantity, :integer, default: 1, null: false
    remove_column :purchased_products, :id
    
  end
end
