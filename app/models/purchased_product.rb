# == Schema Information
#
# Table name: purchased_products
#
#  transaction_id :uuid
#  product_id     :uuid
#

class PurchasedProduct < ApplicationRecord
  belongs_to :order, foreign_key: :transaction_id, class_name: 'Transaction'
  belongs_to :product

  default_scope { includes(:product) }

  delegate :price, to: :product
end
