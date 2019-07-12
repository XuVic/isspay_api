class CreateTransferDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :transfer_details, primary_key: %i[receiver_id transaction_id] do |t|
      t.belongs_to :transaction
      t.belongs_to :receiver, foregin_key: { to_table: :users }
    end
  end
end
