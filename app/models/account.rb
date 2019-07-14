# == Schema Information
#
# Table name: accounts
#
#  id         :uuid             not null, primary key
#  debit      :float            default(0.0), not null
#  credit     :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :uuid
#

class Account < ApplicationRecord
  belongs_to :owner, foreign_key: 'owner_id', class_name: 'User'
  has_many :transactions
  has_many :orders, -> { where 'genre = 0' }, class_name: 'Transaction'
  has_many :transfers, -> { where 'genre = 1' }, class_name: 'Transaction'
  has_many :transfer_details, foreign_key: :receiver_id
  has_many :receipts, through: :transfer_details, source: :transfer

  class MoneyNotEnough < StandardError; end

  def balance
    credit - debit
  end

  def order(products)
    cost = products.reduce(0) { |c, p| c + p.price }
    raise MoneyNotEnough if cost > balance

    ActiveRecord::Base.transaction do
      t = Transaction.create(account: self, genre: 'purchase')
      t.products = products
      t.save
      self.debit += cost
      save
    end
  end

  def transfer(receiver, amount)
    raise MoneyNotEnough if amount > balance

    ActiveRecord::Base.transaction do
      transaction = Transaction.create(account: self, genre: 'transfer')
      TransferDetail.create(receiver: receiver, amount: amount, transfer: transaction)
      receiver.credit += amount
      receiver.save
      self.debit += amount
      save
    end
  end
end
