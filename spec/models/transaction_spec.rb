# == Schema Information
#
# Table name: transactions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid
#  genre      :integer          default("purchase"), not null
#

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:purchase) { create(:transaction, :purchase) }
  let(:transfer) { create(:transaction, :transfer) }
  # it 'debugging' do
  #   binding.pry
  # end

  describe 'Referential Integrity:' do
    context 'when transaction is created as purchase' do
      it 'has many products' do
        products = purchase.products
        products.each do |p|
          expect(p.orders.map(&:id)).to include(purchase.id)
        end
      end
    end

    context 'when transaction is created as transfer' do
      it 'has one receiver' do
        receiver = transfer.receiver
        expect(receiver.receipts).to include(transfer)
      end
    end
  end

  describe 'Domain Integrity:' do
    context 'foreign key constraint(account)' do
      it { expect { create(:transaction, :purchase, account: nil).to raise_error(ActiveRecord::RecordInvalid) } }
    end

    context 'when genre is null' do
      it { expect { create(:transaction, genre: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end
  end
end
