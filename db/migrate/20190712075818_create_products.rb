class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name,             null: false
      t.float :price,             null: false
      t.integer :quantity,        null: false, default: 0
      t.string :image_url,        null: false, default: 'https://i.imgur.com/eYl9RO4.png'

      t.timestamps
    end
  end
end
