require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::AccountsController, type: :request do
  
  let(:endpoint) { '/api/chatfuel/accounts' }
  describe '#show' do
    let(:user) { create(:user).tap { |u| u.confirm } }
    let!(:transaction) { create(:transaction, :purchase, account: user.account) }
    let!(:send_request) { get "#{endpoint}?#{messenger_id_params(user)}" }

    it { expect(response_status).to eq 200 }
    it { expect(response.body).to include((-1 * user.balance).to_s) }
    it { expect(response_body['messages']).not_to be nil }
  end

  describe '#reply' do
    let(:user) { create(:user, :confirmed) }
    let!(:transaction) { create(:transaction, :purchase, account: user.account) }
    let!(:send_request) { get "#{endpoint}/repay?#{messenger_id_params(user)}" }
    let(:account) { Account.where(owner_id: user.id).first! }

    it { expect(response_status).to eq 200 }
    it { expect(account.balance).to eq 0 }
    it { expect(account.orders.unpaid.exists?).to eq false }
    it { expect(account.orders.paid.exists?).to eq true }
  end
end