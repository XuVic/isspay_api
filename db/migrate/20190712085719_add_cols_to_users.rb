class AddColsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table(:users) do |t|
      t.string :first_name
      t.string :last_name
      t.integer :messenger_id, null: false
    end
  end
end
