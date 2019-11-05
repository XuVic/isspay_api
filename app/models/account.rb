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
  has_many :transactions, dependent: :destroy
  has_many :orders, -> { where('genre = 0').order(created_at: :desc) }, class_name: 'Transaction'
  has_many :transfers, -> { where('genre = 1').order(created_at: :desc) }, class_name: 'Transaction'
  has_many :transfer_details, foreign_key: :receiver_id
  has_many :receipts, through: :transfer_details, source: :transfer

  def purchased_products(unpaid: )
    return orders.unpaid.map(&:purchased_products).flatten if unpaid
    orders.map(&:purchased_products).flatten
  end

  def pay!(cost)
    decrement!(:balance, by = cost)
  end

  def receive!(money)
    increment!(:balance, by = money)
  end

  def owner_name
    owner.name
  end
end
