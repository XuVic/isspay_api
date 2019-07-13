class ChangeColNameInTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_columns(:transactions, :type)
    add_column(:transactions, :genre, :integer, null: false, default: 0)
  end
end
