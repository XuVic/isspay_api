class CreatePurchasedProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :purchased_products, primary_key: %i[product_id transaction_id] do |t|
      t.belongs_to :product
      t.belongs_to :transaction
    end
  end
end
