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
  belongs_to :category
  has_many :purchased_products
  has_many :orders, through: :purchased_products
  
  def self.find_by_category(category_name)
    return Product.all unless category_name

    category_id = Category.where(name: category_name).first!
    Product.where(category_id: category_id).all
  end

  def available?
    quantity.positive?
  end
end
