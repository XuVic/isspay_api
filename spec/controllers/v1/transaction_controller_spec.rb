require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do

  
  let(:endpoint) { '/api/v1/transactions' }
  let(:admin_token) { create_admin_token }

  describe '#index' do
    before :all do
      @users = 2.times.map { create(:user) }
      @transactions_1 = 5.times.map { create(:transaction, :purchase, account: @users[0].account) }
      @transactions_2 = 10.times.map { create(:transaction, :purchase, account: @users[1].account) }
    end

    let(:tokens) { @users.map { |u| create_token(u) } }
    let(:query_string) { "account_ids[]=#{@users[0].account.id}&account_ids[]=#{@users[1].account.id}" }

    context 'when login as user A' do
      context 'and query string is nil (i.e access his own resources)' do
        let!(:send_request) { get endpoint, headers: auth_header(tokens[0]) }

        it { expect(response_status).to eq 200 }
        it { expect(response_data.size).to eq @transactions_1.size }
      end

      context 'and query string has account_ids (i.e access others resources)' do
        let!(:send_request) { get "#{endpoint}?#{query_string}", headers: auth_header(tokens[0]) }

        it { expect(response_status).to eq 403 }
      end
    end

    context 'when login as admin' do
      context 'and query string has account_ids' do
        let!(:send_request) { get "#{endpoint}?#{query_string}", headers: auth_header(admin_token) }

        it { expect(response_status).to eq 200 }
        it { expect(response_data.size).to eq @transactions_1.size + @transactions_2.size }
      end
    end
  end

  describe '#create' do
    let(:user) { create(:user) }
    let(:token) { create_token(user) }
    let(:products) { 5.times.map { create(:product, :snack) } + 5.times.map { create(:product, :drink) } }
    
    context 'when login as normal user' do
      context 'and purchase data is valid' do
        let(:params) { products.map { |p| { product_id: p.id, quantity: p.quantity - 1 } } }
        let!(:send_request) { post endpoint, params: { purchases: params, transaction: { genre: 'purchase' } }, headers: auth_header(token) }

        it { expect(response_status).to eq 201 }
        it { expect(Product.find(products[0].id).quantity).to eq 1 }
        it { expect(response_data['attributes']['amount']).to eq products.reduce(0) { |s, p| s+= p.price * (p.quantity - 1) } }
        it { expect(User.find(user.id).balance).to eq user.balance - response_data['attributes']['amount'] }
      end

      context 'and products is out of stock' do
        let(:invalid_params) { products.map { |p| { product_id: p.id, quantity: p.quantity + 1 } } }
        let!(:send_request) { post endpoint, params: { purchases: invalid_params, transaction: { genre: 'purchase' } }, headers: auth_header(token) }

        it { expect(response_status).to eq 404 }
      end

      let(:giver) { create(:user) }
      let(:receiver) { create(:user) }
      let(:giver_token) { create_token(giver) }
      context 'and transfer data is valid' do
        let(:params) { [{ amount: 100, receiver_id: receiver.id }] }
        let!(:send_request) { post endpoint, params: { transfers: params, transaction: { genre: 'transfer' } }, headers: auth_header(giver_token) }

        it { expect(response_status).to eq 201 }
        it { expect(User.find(receiver.id).balance).to eq receiver.balance + 100 }
        it { expect(User.find(giver.id).balance).to eq giver.balance - 100 }
      end

      context 'and transfer data is invalid' do
        let(:invalid_params) { [{amount: -2, receiver_id: receiver.id}] }
        let!(:send_request) { post endpoint, params: { transfers: invalid_params, transaction: { genre: 'transfer' } }, headers: auth_header(giver_token) }

        it { expect(response_status).to eq 404 }
      end
    end
  end

  describe '#destroy' do
    context 'when login as UserA' do
      before :all do
        @user = create(:user)
        @purchase = create(:transaction, :purchase, account: @user.account)
        @cost = @purchase.amount
        @prev_order = @user.orders.size 
      end
      
      let(:token) { create_token(@user) }

      context 'and destroy his own transactaion' do
        let!(:send_request) { delete "#{endpoint}/#{@purchase.id}", headers: auth_header(token) }
        
        it { expect(response_status).to eq 200 }
        it { expect{ Transaction.find(@purchase.id) }.to raise_error(ActiveRecord::RecordNotFound) }
        it { expect(User.find(@user.id).orders.size).to eq @prev_order - 1 }
        it { expect(User.find(@user.id).balance).to eq @user.balance + @cost  }
      end

      context 'and destroy other transaction' do
        let(:transaction) { create(:transaction, :purchase) }
        let!(:send_request) { delete "#{endpoint}/#{transaction.id}", headers: auth_header(token) }
      
        it { expect(response_status).to eq 403 }
        it { expect(Transaction.where(id: transaction.id).exists?).to eq true }
      end

      context 'and transaction cannot be found' do
        let!(:send_request) { delete "#{endpoint}/wrong_id", headers: auth_header(token) }
        
        it { expect(response_status).to eq 404 }
      end

      context 'and destroy his own transfer' do
        before :all do
          @giver = create(:user)
          @transfer = create(:transaction, :transfer, account: @giver.account)
          @prev_cost = @transfer.amount
          @receiver = @transfer.receivers[0]
        end

        let(:token) { create_token(@giver) }
        let!(:send_request) { delete "#{endpoint}/#{@transfer.id}", headers: auth_header(token) }

        it { expect(response_status).to eq 200 }
        it { expect(Account.find(@receiver.id).balance).to eq @receiver.balance - @prev_cost }
        it { expect(User.find(@giver.id).balance).to eq @giver.balance + @prev_cost }
      end
    end
  end
end