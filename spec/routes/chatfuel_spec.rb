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
        expect(get('/api/chatfuel/delete_transaction'))
          .to route_to(controller: 'api/chatfuel/transactions', action: 'destroy')
      end
    end
  end

  describe 'chatfuel/products controller' do
    context 'get products list' do
      it do
        expect(get('api/chatfuel/products'))
          .to route_to(controller: 'api/chatfuel/products', action: 'index')
      end
    end
  end
end
