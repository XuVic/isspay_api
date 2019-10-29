class AddIndxToProducts < ActiveRecord::Migration[6.0]
  def change
    add_index :products, :category  
  end
end
