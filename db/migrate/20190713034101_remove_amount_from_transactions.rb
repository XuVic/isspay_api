class RemoveAmountFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_columns(:transactions, :amount)
  end
end
