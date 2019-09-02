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

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:purchase) { create(:transaction, :purchase) }
  let(:transfer) { create(:transaction, :transfer) }

  describe 'CallBacks:' do
    before :all do
      @user = create(:user)
      @user.credit = 100
      @user.save
      @product = create(:product, :snack, price: 100)
      @transaction = @user.order([@product])
    end

    context 'before_destroy' do
      before :all do
        @transaction.destroy
      end

      it 'also rollbacks account data' do
        expect(User.find(@user.id).balance).to eq 100
        expect(Product.find(@product.id).quantity).to eq @product.quantity + 1
      end

      it { expect(PurchasedProduct.where(transaction_id: @transaction.id)).to be_empty }

      it do
        expect{ Transaction.find(@transaction.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

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

    context 'when state is null' do
      it { expect { create(:transaction, state: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end
  end
end
