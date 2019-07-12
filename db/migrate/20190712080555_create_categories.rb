class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_reference(:products, :category, foreign_key: true)
  end
end
