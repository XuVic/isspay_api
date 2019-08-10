require 'rails_helper'

Rails.describe Api::V1::UsersController, type: :request do
  describe '#create_token' do
    context 'valid credentials' do
      before(:all) do
        user = create(:user, role: 'master')
        post '/api/v1/users/auth', params: { user: { email: user.email, password: user.password } }
        @response_body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq 200 }
      it { expect(response.get_header('Content-Type')).to include('application/json') }
      it { expect(@response_body['message']['access_token']).not_to be_nil }
      it { expect(@response_body['message']['refresh_token']).not_to be_nil }
    end

    context 'invald credentials' do
      before(:all) do
        post '/api/v1/users/auth', params: { user: { email: 'nobody@mail.com', password: 'abcd1234' } }
        @response_body = JSON.parse(response.body)
      end

      it { expect(response.status).to eq 401 }
      it { expect(@response_body['error'][0]).to eq "Credentials is not valid." }
    end
  end
end