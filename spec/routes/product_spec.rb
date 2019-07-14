require 'rails_helper'

RSpec.describe 'Routes for Products', type: :routing do
  describe 'v1/products controller' do
    context 'create a product' do
      it do
        expect(post('/api/v1/products'))
          .to route_to(controller: 'api/v1/products', action: 'create')
      end
    end

    context 'read all products' do
      it do
        expect(get('/api/v1/products'))
          .to route_to(controller: 'api/v1/products', action: 'index')
      end
    end

    context 'update a product' do
      it do
        expect(put('/api/v1/products/1'))
          .to route_to(controller: 'api/v1/products', action: 'update', id: '1')
      end
    end

    context 'delete a product' do
      it do
        expect(delete('/api/v1/products/1'))
          .to route_to(controller: 'api/v1/products', action: 'destroy', id: '1')
      end
    end
  end
end
