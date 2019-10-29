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

FactoryBot.define do
  factory :transaction do
    association :account, factory: :account
    state { 0 }
    trait :purchase do
      genre { 0 }
      after(:create) do |t|
        products = 5.times.map { FactoryBot.create(:product, category: 'snack') }
        t.purchased_products_attributes = products.map { |p| { product_id: p.id, quantity: 1 } }
        t.set_amount!
        t.save
        t.account.pay!(t.amount)
        products.each { |p| p.decrement!(:quantity, size = 1) }
      end
    end

    trait :transfer do
      genre { 1 }
      after(:create) do |t|
        receiver = FactoryBot.create(:user)
        t.transfer_details_attributes = [{receiver_id: receiver.account.id, amount: 50}]
        t.set_amount!
        t.save
        receiver.account.increment!(:balance, size = t.amount)
        t.account.pay!(t.amount)
      end
    end
  end
end
