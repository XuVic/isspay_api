# == Schema Information
#
# Table name: transactions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid
#  genre      :integer          default("purchase"), not null
#

class Transaction < ApplicationRecord
  has_many :purchased_products
  has_many :products, through: :purchased_products
  has_one :transfer_detail
  has_one :receiver, through: :transfer_detail
  belongs_to :account

  enum genre: %i[purchase transfer]
end
