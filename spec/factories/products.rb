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

FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "#{Faker::Food.dish}-#{n}" }

    price { Random.rand(100) }
    cost { 0 }
    quantity { Random.rand(10..50) }
    image_url { 'https://i.imgur.com/eYl9RO4.png' }
    category { ['snack', 'drink'].shuffle.first }
  end
end
