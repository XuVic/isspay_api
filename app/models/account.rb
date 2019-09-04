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

  def pay!(cost)
    increment!(:debit, by = cost)
  end

  def order(products, options = {})
    cost = products.reduce(0) { |c, p| c + p.price }
    raise TransactionInvalid if (cost > balance && !options[:allowed]) || !products_available?(products)

    self.class.transaction do
      t = Transaction.create(account: self, genre: 'purchase')
      t.products = products
      t.save
      purchased_products(products)
      self.debit += cost
      save
      t
    end
  end

  def transfer(receiver, amount)
    raise TransactionInvalid if amount > balance

    self.class.transaction do
      transaction = Transaction.create(account: self, genre: 'transfer')
      TransferDetail.create(receiver: receiver, amount: amount, transfer: transaction)
      receiver.credit += amount
      receiver.save
      self.debit += amount
      save
    end
  end

  def consumption(months)
    now = Time.now
    Array(0..months).inject([]) do |result, month|
      new_time = TimeDecorator.new(Time.now).ago(month * 30)
      selected_orders = orders.select { |o| new_time.between?(o.created_at) }
      result << {
        date: new_time.strftime('%Y/%m'),
        products: selected_orders.reduce(0) { |sum, o| sum += o.products.size },
        cost: selected_orders.reduce(0) { |sum, o| sum += o.amount }
      }
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
    self.class.transaction do
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
