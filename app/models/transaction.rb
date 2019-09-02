# == Schema Information
#
# Table name: transactions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid
#  genre      :integer          default("purchase"), not null
#  state      :integer
#

class Transaction < ApplicationRecord
  include AASM

  has_many :purchased_products
  has_many :products, through: :purchased_products
  has_one :transfer_detail
  has_one :receiver, through: :transfer_detail
  belongs_to :account

  enum genre: %i[purchase transfer]
  enum state: %i[unpaid canceled paid]

  delegate :owner, to: :account

  before_destroy do
    if type == 'transfer'
      destroy_transfer
    elsif type == 'purchase'
      destroy_purchase
    end
  end

  aasm column: :state, enum: true do
    state :unpaid, initial: true
    state :canceled, :paid

    event :pay do
      transitions from: :unpaid, to: :paid
    end
  end

  def product_names
    products.map(&:name)
  end

  def amount
    if genre == 'purchase'
      products.reduce(0) { |s, p| s + p.price }
    elsif genre == 'transfer'
      transfer_detail.amount
    end
  end

  def type
    if receiver
      'transfer'
    elsif products
      'purchase'
    end
  end

  private

  def destroy_purchase
    PurchasedProduct.where(transaction_id: self.id).all.each do |purchased|
      product = purchased.product
      product.quantity += 1
      product.save
    end
    account = self.account
    account.debit -= self.amount
    account.save
    self.products.delete_all
  end
  
  def destroy_transfer
  end
end
