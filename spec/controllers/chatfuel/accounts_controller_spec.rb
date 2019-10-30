require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::AccountsController, type: :request do
  
  let(:endpoint) { '/api/chatfuel/accounts' }
  describe '#show' do
    let(:user) { create(:user).tap { |u| u.confirm } }
    let!(:transaction) { create(:transaction, :purchase, account: user.account) }
    let!(:send_request) { get "#{endpoint}?#{messenger_id_params(user)}" }

    it { expect(response_status).to eq 200 }
    it { expect(response.body).to include(user.balance.to_s) }
    it { expect(response_body['messages']).not_to be nil }
  end

  describe '#reply' do
  end
end