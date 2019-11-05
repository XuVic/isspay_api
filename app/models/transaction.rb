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
  has_many :transfer_details
  has_many :receivers, through: :transfer_details
  belongs_to :account

  accepts_nested_attributes_for :transfer_details
  accepts_nested_attributes_for :purchased_products

  enum genre: %i[purchase transfer]
  enum state: %i[unpaid canceled paid]

  delegate :owner, :owner_name, to: :account

  scope :since_scope, -> (date) { where(["created_at >= ?", date]) }
  scope :before_scope, -> (date) { where(["created_at <= ?", date]) }
  scope :genre_scope, -> (genre) { where(genre: genre) }
  scope :state_scope, -> (state) { where(state: state) }
  scope :account_ids_scope, -> (account_ids) { where(["account_id IN (?)", account_ids]) }

  aasm column: :state, enum: true do
    state :unpaid, initial: true
    state :canceled, :paid

    event :pay do
      transitions from: :unpaid, to: :paid
    end
  end

  def amount_range(range)
    min = range[0] || -Float::INFINITY
    max = range[1] || Float::INFINITY  
    amount >= min && amount <= max
  end

  def product_names
    products.map(&:name).join(';')
  end

  def receiver_names
    receivers.map(&:owner_name)
  end

  def set_amount!
    if purchase?
      self.amount = purchased_products.reduce(0) { |s, p| s + (p.price * p.quantity) }
    elsif transfer?
      self.amount = transfer_details.reduce(0) { |s, t| s + t.amount }
    end
    self.save!
  end
  
  def purchase?
    genre == 'purchase'
  end

  def transfer?
    genre == 'transfer'
  end
end
