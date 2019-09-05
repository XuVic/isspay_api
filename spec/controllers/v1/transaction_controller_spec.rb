require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do

  before :all do
    @user_a = create(:user)
    @user_b = create(:user)
    @admin = create(:user, :admin)

    @transactions_a = 5.times.map { create(:transaction, :purchase, account: @user_a.account) }
    @transactions_b = 10.times.map { create(:transaction, :purchase, account: @user_b.account) }
    @transactions_c = 15.times.map { create(:transaction,:purchase, account: @admin.account) }
  end
  
  let(:endpoint) { '/api/v1/transactions' }
  let(:token_a) { create_token(@user_a) }
  let(:token_b) { create_token(@user_b) }
  let(:admin_token) { create_token(@admin) }

  describe '#index' do
    let(:query_string) { "account_ids[]=#{@user_b.account.id}&account_ids[]=#{@admin.account.id}" }

    context 'when login as user A' do
      context 'and query string is nil (i.e access his own resources)' do
        let!(:send_request) { get endpoint, headers: auth_header(token_a) }

        it { expect(response_status).to eq 200 }
        it { expect(response_data.size).to eq @transactions_a.size }
      end

      context 'and query string has account_ids (i.e access others resources)' do
        let!(:send_request) { get "#{endpoint}?#{query_string}", headers: auth_header(token_a) }

        it { expect(response_status).to eq 403 }
      end
    end

    context 'when login as admin' do
      context 'and query string has account_ids' do
        let!(:send_request) { get "#{endpoint}?#{query_string}", headers: auth_header(admin_token) }

        it { expect(response_status).to eq 200 }
        it { expect(response_data.size).to eq @transactions_b.size + @transactions_c.size }
      end
    end
  end

  describe '#create' do
    let(:products) { 5.times.map { create(:product, :snack) } + 5.times.map { create(:product, :drink) } }
  
    context 'when login as normal user' do
      context 'and purchase data is valid' do
        let(:params) { products.map { |p| { product_id: p.id, quantity: p.quantity - 1 } } }
        let!(:send_request) { post endpoint, params: { purchases: params, transaction: { genre: 'purchase' } }, headers: auth_header(token_a) }

        it { expect(response_status).to eq 201 }
        it { expect(Product.find(products[0].id).quantity).to eq 1 }
        it { expect(User.find(@user_a.id).balance).to eq @user_a.balance - response_data['attributes']['amount'] }
      end

      context 'and products is out of stock' do
        let(:invalid_params) { products.map { |p| { product_id: p.id, quantity: p.quantity + 1 } } }
        let!(:send_request) { post endpoint, params: { purchases: invalid_params, transaction: { genre: 'purchase' } }, headers: auth_header(token_a) }

        it { expect(response_status).to eq 404 }
      end

      context 'and transfer data is valid' do
        let(:params) { [{ amount: 100, receiver_id: @user_b.id }] }
        let!(:send_request) { post endpoint, params: { transfers: params, transaction: { genre: 'transfer' } }, headers: auth_header(token_a) }

        it { expect(response_status).to eq 201 }
        it { expect(User.find(@user_b.id).balance).to eq @user_b.balance + 100 }
        it { expect(User.find(@user_a.id).balance).to eq @user_a.balance - 100 }
      end

      context 'and transfer data is invalid' do
        let(:invalid_params) { [{amount: -2, receiver_id: @user_b.id}] }
        let!(:send_request) { post endpoint, params: { transfers: invalid_params, transaction: { genre: 'transfer' } }, headers: auth_header(token_a) }

        it { expect(response_status).to eq 404 }
      end
    end
  end

  # describe '#destroy' do
  #   context 'when login as UserA' do
  #     context 'and destroy his own transactaion' do
  #       let!(:send_request) { delete "#{endpoint}/#{@transactions_a[0].id}", headers: auth_header(token_a) }
        
  #       it { expect(response_status).to eq 200 }
  #       it { expect{ Transaction.find(transactions_a[0].id) }.to raise_error(ActiveRecord::RecordNotFound) }
  #     end

  #     context 'and destroy other transaction' do
  #       let!(:send_request) { delete "#{endpoint}/#{@transactions_b[0].id}", headers: auth_header(token_a) }
      
  #       it { expect(response_status).to eq 403 }
  #       it { expect(Transaction.where(id: @transactions_b[0].id).exists?).to eq true }
  #     end

  #     context 'and transaction cannot be found' do
  #       let!(:send_request) { delete "#{endpoint}/wrong_id", headers: auth_header(token_a) }
        
  #       it { expect(response_status).to eq 404 }
  #     end
  #   end
  # end
end