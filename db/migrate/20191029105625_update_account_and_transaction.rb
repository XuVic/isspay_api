class UpdateAccountAndTransaction < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :credit, :balance
    remove_column :accounts, :debit
    remove_column :accounts, :owner_id

    add_column :transactions, :amount, :float, null: :false

    create_join_table :users, :accounts
  end
end
