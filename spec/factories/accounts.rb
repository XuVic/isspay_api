# == Schema Information
#
# Table name: accounts
#
#  id         :uuid             not null, primary key
#  debit      :float            default(0.0), not null
#  credit     :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :uuid
#

FactoryBot.define do
  factory :account do
    credit { 1000 }
    debit { 500 }
    association :owner, factory: :user
  end
end
