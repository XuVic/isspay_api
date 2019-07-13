class AlterPurchasedProducts < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:purchased_products, :transaction)
    remove_reference(:purchased_products, :product)
    add_reference(:purchased_products, :transaction, type: :uuid, forgin_key: true)
    add_reference(:purchased_products, :product, type: :uuid, forgin_key: true)
  end
end
