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

  def receive!(money)
    increment!(:credit, by = money)
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

  def owner_name
    owner.name
  end
end
