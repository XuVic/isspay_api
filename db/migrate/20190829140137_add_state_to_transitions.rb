class AddStateToTransitions < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :status
    add_column :transactions, :state, :integer
  end
end
