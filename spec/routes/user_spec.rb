require 'rails_helper'

RSpec.describe 'Routes for Users', type: :routing do
  describe 'v1/user controller' do
    context 'user signup' do
      it do
        expect(post('/api/v1/users'))
          .to route_to(controller: 'api/v1/users', action: 'create')
      end
    end

    context 'user signin' do
      it do
        expect(post('api/v1/users/sign_in'))
          .to route_to(controller: 'api/v1/users', action: 'sign_in')
      end
    end

    context 'user signout' do
      it do
        expect(delete('api/v1/users/sign_out'))
          .to route_to(controller: 'api/v1/users', action: 'sign_out')
      end
    end

    context 'list users' do
      it do
        expect(get('/api/v1/users'))
          .to route_to(controller: 'api/v1/users', action: 'index')
      end
    end

    context 'read data of a user' do
      it do
        expect(get('/api/v1/users?id=1'))
          .to route_to(controller: 'api/v1/users', action: 'index', id: '1')
      end
    end

    context 'update data of a user' do
      it do
        expect(put('/api/v1/users/1'))
          .to route_to(controller: 'api/v1/users', action: 'update', id: '1')
      end
    end
  end
end
