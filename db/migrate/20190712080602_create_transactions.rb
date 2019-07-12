class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions, id: :uuid do |t|
      t.float :amount,            null: false, default: 0
      t.integer :type,            null: false, default: 0
      t.timestamps
    end

    add_reference(:transactions, :account, type: :uuid, foregin_key: true)
  end
end
