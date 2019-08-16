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
  let(:products) do
    10.times.map { create(:product, :snack, price: 100) } 
  end

  # it 'debugging' do
  #   binding.pry
  # end

  describe '#order' do
    context 'not enough money' do
      it { expect { account.order(products) }.to raise_error(Account::TransactionInvalid) }
    end

    context 'products are not avilable' do
      let(:unavailable_products) do
        product = create(:product, :snack, quantity: 5)
        10.times.map { Product.where(id: product.id).first }
      end

      it { expect { account.order(unavailable_products) }.to raise_error(Account::TransactionInvalid) }
    end

    context 'enough money' do
      it 'create a transaction' do
        pre_balance = account.balance
        pre_quantity = products[0].quantity
        cost = products[0..1].reduce(0) { |c, p| c + p.price }
        account.order(products[0..1])
        expect(products[0].quantity).to eq(pre_quantity - 1)
        expect(account.orders[0].products.sort).to eq(products[0..1].sort)
        expect(account.balance).to eq(pre_balance - cost)
      end
    end
  end

  describe '#transfer' do
    context 'not enough money' do
      it { expect { account.transfer(receiver, 100000).to raise_error(Account::TransactionInvalid) } }
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

  describe "#consumption" do
    it 'create a consumption hash' do
      account.order(products, allowed: true)
      cost = products.reduce(0) { |c, p| c + p.price }
      expect(account.consumption(2).size).to eq 3
      expect(account.consumption(2)[0].keys.sort).to eq [:date, :products, :cost].sort
      expect(account.consumption(0)[0][:cost]).to eq cost
    end
  end
end
