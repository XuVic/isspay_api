require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do

  let(:endpoint) { '/api/v1/transactions' }
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:user_token) { create_token(user) }
  let(:admin_token) { create_token(admin) }
  let!(:transactions) { 5.times.map { create(:transaction, :purchase, account: user.account) } }
  let!(:admin_transactions) { 3.times.map { create(:transaction, :purchase, account: admin.account) } }

  describe '#index' do
    context 'login as normal user' do
      it 'return successful response' do
        get endpoint, headers: { Authorization: "Bearer #{user_token}" }
        expect(response.status).to eq 200
        expect(response_body['type']).to eq 'resource' 
        expect(response_body['resource'].size).to eq transactions.size
        expect(resource_attributes).to include('amount')
      end

      it 'return unathorized error' do
        query_string = "account_ids[]=#{user.account.id}&account_ids[]=#{admin.account.id}"
        get "#{endpoint}?#{query_string}", headers: { Authorization: "Bearer #{user_token}" }
        expect(response.status).to eq 403
      end
    end

    context 'login as admin' do
      it 'return sucessful response' do
        query_string = "account_ids[]=#{user.account.id}&amount=#{transactions[0].amount}:&state=unpaid&since=#{transactions[0].created_at.to_i}"
        get "#{endpoint}?#{query_string}", headers: { Authorization: "Bearer #{user_token}" }
        expect(response.status).to eq 200
        expect(response_body['type']).to eq 'resource' 
      end
    end
  end

  describe '#create' do
  end

  describe '#destroy' do
  end

end