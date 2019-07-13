class AlterReceiverIdTransferDetails < ActiveRecord::Migration[5.2]
  def change
    remove_reference(:transfer_details, :receiver)
    add_reference(:transfer_details, :receiver, type: :uuid, forgin_key: { to_table: :account })
  end
end
