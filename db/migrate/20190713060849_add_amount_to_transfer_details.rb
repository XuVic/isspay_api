class AddAmountToTransferDetails < ActiveRecord::Migration[5.2]
  def change
    add_column(:transfer_details, :amount, :float, null: false)
  end
end
