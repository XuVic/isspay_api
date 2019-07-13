class AlterTransferDetails < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:transfer_details, :transaction)
    remove_reference(:transfer_details, :receiver)
    add_reference(:transfer_details, :transaction, type: :uuid, forgin_key: true)
    add_reference(:transfer_details, :receiver, type: :uuid, forgin_key: { to_table: :users })
  end
end
