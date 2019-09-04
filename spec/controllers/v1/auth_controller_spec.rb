require 'rails_helper'

Rails.describe Api::V1::UsersController, type: :request do
  describe '#create_token' do
    let(:user) { create(:user, role: 'master') }
    let(:endpoint) { '/api/v1/users/auth' }

    context 'when credentials are valid ' do
      let!(:request) { post endpoint, params: { user: { email: user.email, password: user.password } } }
      
      it { expect(response_status).to eq 201 }
      it { expect(response_data['access_token']).not_to be_nil }
      it { expect(response_data['refresh_token']).not_to be_nil }
    end

    context 'when credentials are invalid' do
      let!(:request) { post endpoint, params: { user: { email: 'nobody@example.com', password: 'abcd1234' } } }

      it { expect(response_status).to eq 401 }
      it { expect(response_type).to eq 'error' }
      it { expect(response_data[0]).to eq "Credentials is not valid." }
    end

    context 'when receive refresh token' do
      let(:refresh_token) { create_refresh_token(user) }
      let!(:request) { post endpoint, params: { refresh_token: refresh_token  } }

      it { expect(response_status).to eq 201 }
      it { expect(response_data['access_token']).not_to be_nil }
      it { expect(response_data['refresh_token']).not_to be_nil }
    end
  end
end