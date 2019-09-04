require 'rails_helper'

Rails.describe Api::V1::UsersController, type: :request do
  describe '#create' do
    let(:endpoint) { '/api/v1/users' }
    
    context 'when submit data is valid' do
      let!(:send_request) { post endpoint, params: { user: attributes } }
      let(:attributes) { attributes_for(:user) }
      let(:user) { User.where(email: attributes[:email]) }

      it { expect(user.exists?).to eq true }
      it { expect(response_type).to eq 'resource' }
      it { expect(response_data['attributes']['email']).to eq attributes[:email] }
    end

    context 'when submit is invalid' do
      let!(:send_request) { post endpoint, params: { user: invalid_attributes } }
      let(:invalid_attributes) { { email: 'test', password: 'test', password_confirmation: 'test123' } }
      let(:user) { User.where(email: invalid_attributes[:email]) }

      it { expect(response_status).to eq 422 }
      it { expect(user.exists?).to eq false }
      it { expect(response_type).to eq 'error' }
    end

    context 'when submit data is empty' do
      let!(:send_request) { post endpoint }

      it { expect(response_status).to eq 400 }
      it { expect(response_type).to eq 'error' }
    end
  end
end