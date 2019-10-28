require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::UsersController, type: :request do
  include ActiveJob::TestHelper

  describe '#create' do
    let(:endpoint) { '/api/chatfuel/users' }  
    context 'when submit data is correct' do
      let(:params) { attributes_for(:user, email: 'test@iss.nthu.edu.tw').tap { |u| u.delete(:password); u.delete(:password_confirmation) }  }
      let!(:send_request) { post endpoint, params: { user: params } }

      it { expect(response_status).to eq 200 }
      it { expect(response_body['messages']).not_to be_empty }
      it { assert_enqueued_jobs 1 }
    end

    context 'when user information is duplicated' do
      let(:user) { create(:user, email: 'test@iss.nthu.edu.tw') }
      let(:params) { user.attributes.tap { |u| u.delete(:password) } }
      let!(:send_request) { post endpoint, params: { user: params } }

      it { expect(response_status).to eq 200 }
      it { assert_enqueued_jobs 0 }
      it { expect(response_body['messages']).not_to be_empty }
    end

    context 'when uesr information is invalid' do
      let(:params) { attributes_for(:user).tap { |u| u.delete(:messenger_id) } }
      let!(:send_request) { post endpoint, params: { user: params } }

      it { expect(response_status).to eq 200 }
      it { assert_enqueued_jobs 0 }
      it { expect(response_body['messages']).not_to be_empty }
    end
  end

  describe "#set_admin" do
    let(:user) { create(:user, admin: false) }
    let(:endpoint) { "/api/chatfuel/users/set_admin" }
    context 'set user as admin' do
      let(:params) { { messenger_id: user.messenger_id, admin: true } }
      let!(:send_request) { post endpoint, params: { user: params } }
      
      it { expect(User.find(user.id).admin?).to be true }
    end

    context 'cancel admin' do
      let(:params) { { messenger_id: user.messenger_id, admin: 'false' } }
      let!(:send_request) { post endpoint, params: { user: params } }
      
      it { expect(User.find(user.id).admin?).to be false }
    end
  end

  after do
    clear_enqueued_jobs
  end
end