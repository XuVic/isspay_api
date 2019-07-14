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

require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { create(:account) }
  let(:receiver) { create(:account) }

  # it 'debugging' do
  #   binding.pry
  # end

  describe '#order' do
    let(:products) { 10.times.map { create(:product, :snack, price: 100) } }

    context 'not enough money' do
      it { expect { account.order(products) }.to raise_error(Account::MoneyNotEnough) }
    end

    context 'enough money' do
      it 'create a transaction' do
        pre_balance = account.balance
        account.order(products[0..1])
        cost = products[0..1].reduce(0) { |c, p| c + p.price }
        expect(account.orders[0].products).to eq(products[0..1])
        expect(account.balance).to eq(pre_balance - cost)
      end
    end
  end

  describe '#transfer' do
    context 'not enough money' do
      it { expect { account.transfer(receiver, 100000).to raise_error(Account::MoneyNotEnough) } }
    end

    context 'enough money' do
      it 'create a transaction' do
        pre_balance = account.balance
        receiver_balance = receiver.balance
        account.transfer(receiver, 20)
        expect(receiver.receipts[0].amount).to eq(20)
        expect(receiver.balance).to eq(receiver_balance + 20)
        expect(account.transfers[0].receiver).to eq(receiver)
        expect(account.balance).to eq(pre_balance - 20)
      end
    end
  end
end
