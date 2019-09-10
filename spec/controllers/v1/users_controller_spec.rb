require 'rails_helper'

Rails.describe Api::V1::UsersController, type: :request do
  let(:endpoint) { '/api/v1/users' }
  describe '#confirmation' do
    context 'when confirmation token is valid' do
      let(:user) { create(:user) }
      let!(:send_request) { get "#{endpoint}/confirmation/#{user.confirmation_token}" }

      it { expect(response_status).to eq 200 }
    end

    context 'when confirmation token is invalid' do
      let!(:send_request) { get "#{endpoint}/confirmation/123456" }

      it { expect(response_status).to eq 400 }
    end
  end
end