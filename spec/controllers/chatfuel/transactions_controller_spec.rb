require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::TransactionsController, type: :request do  
  let(:user) { create(:user) }
  let(:messenger_id) { user.messenger_id }

  describe '#create' do
    let(:endpoint) { '/api/chatfuel/create_transaction' }

    context 'when purchase a product' do
      let(:product) { create(:product, category: 'snack') }
      let(:query_str) { "user[messenger_id]=#{messenger_id}&transaction[purchased_products_attributes][][product_id]=#{product.id}&transaction[purchased_products_attributes][][quantity]=1&transaction[genre]=purchase" }
      let(:template) { Hash.symbolize(transaction_reply) }  
      context 'and messenger_id is correct' do
        let!(:send_request) { get "#{endpoint}?#{query_str}" }
      
        it { expect(response_status).to eq 200 }
        it { expect(User.find(user.id).balance).to eq user.balance - product.price }
        it { expect(response_body.same_key_structure?(template)).to be true }
      end
    end

    context 'when transfer the money' do
      let(:giver) { create(:user) }
      let(:giver_messenger_id) { giver.messenger_id }
      let(:receiver) { create(:user) }
      let(:query_str) { "user[messenger_id]=#{giver_messenger_id}&transaction[transfer_details_attributes][][receiver_id]=#{receiver.account.id}&transaction[transfer_details_attributes][][amount]=100&transaction[genre]=transfer" }
      let!(:send_request) { get "#{endpoint}?#{query_str}" }

      it { expect(response_status).to eq 200 }
      it { expect(User.find(giver.id).balance).to eq giver.balance - 100 }
      it { expect(User.find(receiver.id).balance).to eq receiver.balance + 100 }
    end
  end

  describe '#destroy' do
    before :all do
      @user = create(:user)
      @transaction = create(:transaction, :purchase, account: @user.account)
      get "/api/chatfuel/delete_transaction/#{@transaction.id}?user[messenger_id]=#{@user.messenger_id}"
    end

    it { expect(response.status).to eq 200 }
    it { expect(User.find(@user.id).balance).to eq @transaction.amount + @user.balance }
    it { expect(response.body).to include "#{User.find(@user.id).balance}" }
  end
end