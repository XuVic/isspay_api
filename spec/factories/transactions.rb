# == Schema Information
#
# Table name: transactions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid
#  genre      :integer          default("purchase"), not null
#  status     :integer          default(0), not null
#

FactoryBot.define do
  factory :transaction do
    association :account, factory: :account
    status { 0 }
    trait :purchase do
      genre { 0 }
      after(:create) do |t|
        products = 5.times.map { FactoryBot.create(:product, :snack) }
        t.products = products
      end
    end

    trait :transfer do
      genre { 1 }
      after(:create) do |t|
        receiver = FactoryBot.create(:user)
        TransferDetail.create(receiver: receiver.account,
                              transfer: t, amount: 50)
      end
    end
  end
end
