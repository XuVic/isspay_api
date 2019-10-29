# == Schema Information
#
# Table name: products
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  price       :float            not null
#  quantity    :integer          default(0), not null
#  image_url   :string           default("https://i.imgur.com/eYl9RO4.png"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#

class Product < ApplicationRecord
  has_many :purchased_products
  has_many :orders, through: :purchased_products 

  scope :quantity_scope, -> (range=[]) { where(quantity: to_range(range)) }
  scope :price_scope, -> (range=[]) { where(price: to_range(range)) }
  scope :category_scope, -> (category_id) { where(category_id: category_id) }

  def self.paginate(page, size)
    skips = page < 1 ? 1 : (page - 1) * size
    
    Product.offset(skips).limit(size)
  end

  def available?
    quantity.positive?
  end
end
