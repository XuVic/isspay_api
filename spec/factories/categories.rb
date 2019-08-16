# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :category do
    name { %i[snack drink].sample }
  end

  # initialize_with { Category.find_or_create_by(name: name) }
end
