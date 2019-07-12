class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts, id: :uuid do |t|
      t.float :debit,                  null: false, default: 0, comment: '借'
      t.float :credit,                 null: false, default: 0, comment: '貸'

      t.timestamps
    end

    add_reference(:accounts, :owner, type: :uuid, foreign_key: { to_table: :users })
  end
end
