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

require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:snack) { create(:product, :snack) }
  subject(:record_invalid) { ActiveRecord::RecordInvalid }
  subject(:not_null) { ActiveRecord::NotNullViolation }
  # it 'debugging' do
  #   binding.pry
  # end

  describe 'Referential Integrity:' do
    context 'foreign key constraint' do
      it { expect { create(:product, category: nil) }.to raise_error(record_invalid) }
    end

    context 'when snack is created' do
      it 'is referenced to a category' do
        category = snack.category
        expect(category.products.map(&:id)).to include(snack.id)
      end
    end

    context 'when snack is destroyed' do
      it 'category should be still exist' do
        category_id = snack.category.id
        snack.destroy
        expect(Category.find(category_id)).to be_instance_of(Category)
      end
    end
  end

  describe 'Domain Integrity:' do
    def self.not_null_violation(attribute)
      context "when #{attribute.keys[0]} is nil" do
        it { expect { create(:product, :snack, attribute) }.to raise_error(not_null) }
      end
    end

    not_null_violation(name: nil)
    not_null_violation(price: nil)
    not_null_violation(quantity: nil)
    not_null_violation(image_url: nil)

    context 'when price is a string' do
      it { expect(create(:product, :snack, price: 'abc').price).to eq(0.0) }
    end

    context 'when quantity is a string' do
      it { expect(create(:product, :snack, quantity: 'abc').quantity).to eq(0.0) }
    end
  end
end
