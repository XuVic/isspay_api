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

  class TransactionInvalid < StandardError; end

  def balance
    credit - debit
  end

  def order(products)
    cost = products.reduce(0) { |c, p| c + p.price }
    raise TransactionInvalid if cost > balance || !products_available?(products)

    ActiveRecord::Base.transaction do
      t = Transaction.create(account: self, genre: 'purchase')
      t.products = products
      t.save
      purchased_products(products)
      self.debit += cost
      save
    end
  end

  def transfer(receiver, amount)
    raise TransactionInvalid if amount > balance

    ActiveRecord::Base.transaction do
      transaction = Transaction.create(account: self, genre: 'transfer')
      TransferDetail.create(receiver: receiver, amount: amount, transfer: transaction)
      receiver.credit += amount
      receiver.save
      self.debit += amount
      save
    end
  end

  private

  def products_available?(products)
    products_hash(products).each do |k, v|
      product = products_hash[k][0]

      return false if !product.available? || product.quantity < v.count
    end
    true
  end

  def purchased_products(products)
    ActiveRecord::Base.transaction do
      products_hash(products).each do |k, v|
        product = products_hash[k][0]
        product.quantity -= v.count
        product.save
      end
    end
  end

  def products_hash(products = nil)
    return @products_hash unless products

    @products_hash = products.group_by(&:id)
  end
end
