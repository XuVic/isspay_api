class AddIdToPurchasedProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :purchased_products, :id, :primary_key
  end
end
