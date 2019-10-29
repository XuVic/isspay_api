class DropJoinUsersAccounts < ActiveRecord::Migration[6.0]
  def change
    drop_table :accounts_users

    add_reference(:accounts, :owner, type: :uuid, foreign_key: { to_table: :users })
  end
end
