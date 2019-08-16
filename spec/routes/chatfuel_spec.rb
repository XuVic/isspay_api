require 'rails_helper'

RSpec.describe 'Routes for Chatfuel scope', type: :routing do
  describe 'chatfuel/transactions controller' do
    context 'create a transaction' do
      it do
        expect(get('/api/chatfuel/create_transaction'))
          .to route_to(controller: 'api/chatfuel/transactions', action: 'create')
      end
    end

    context 'delete a transaction' do
      it do
        expect(get('/api/chatfuel/delete_transaction/1'))
          .to route_to(controller: 'api/chatfuel/transactions', action: 'destroy', id: '1')
      end
    end
  end

  describe 'chatfuel/products controller' do
    context 'get products list' do
      it do
        expect(get('/api/chatfuel/products'))
          .to route_to(controller: 'api/chatfuel/products', action: 'index')
      end
    end
  end

  describe 'chatfuel/accounts controller' do
    context 'check balance' do
      it do
        expect(get('/api/chatfuel/accounts/123456?fields[]=balance'))
          .to route_to(controller: 'api/chatfuel/accounts', action: 'show', messenger_id: "123456", fields: ['balance'])
      end
    end

    context 'check consumption record' do
      it do
        expect(get('/api/chatfuel/accounts/123456?fields[]=consumption'))
          .to route_to(controller: 'api/chatfuel/accounts', action: 'show', messenger_id: "123456", fields: ['consumption'])
      end
    end

    context 'repayment' do
      it do
        expect(get('/api/chatfuel/repayment'))
          .to route_to(controller: 'api/chatfuel/accounts', action: 'repay')
      end
    end
  end

  describe 'chatfuel/users controller' do
    context 'switch membership' do
    end
  end
end
