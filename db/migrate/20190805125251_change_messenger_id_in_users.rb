class ChangeMessengerIdInUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :messenger_id
    add_column :users, :messenger_id, :string
  end
end
