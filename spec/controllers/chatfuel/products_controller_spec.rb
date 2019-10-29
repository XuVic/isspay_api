require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::ProductsController, type: :request do
  include ActiveJob::TestHelper

  before :all do
    20.times { create(:product, category: 'snack') }
  end

  let(:messenger_id) { create(:user).tap { |u| u.confirm }.messenger_id }
  let(:endpoint) { '/api/chatfuel/products' }
  describe '#index' do
    context 'when inventory has products' do
      let(:query_str) { "user[messenger_id]=#{messenger_id}&product[category]=snack&page=1" }
      let(:template) { Hash.symbolize(gallery_template) }
      let!(:send_request) { get "#{endpoint}?#{query_str}" }

      it { expect(response_status).to eq 200 }
      it { expect(response_body.same_key_structure? template).to be true  }

      context 'and page is out of range' do
        let(:query_str) { "user[messenger_id]=#{messenger_id}&product[category]=snack&page=20" }
        let!(:send_request) { get "#{endpoint}?#{query_str}" }

        it { expect(response_status).to eq 200 }
        it { expect(response.body).to include('沒有庫存') }
      end
    end


    context 'when inventory has no products' do
      let(:query_str) { "user[messenger_id]=#{messenger_id}&product[category]=drink&page=1" }
      let!(:send_request) { get "#{endpoint}?#{query_str}" }
      
      it { expect(response_status).to eq 200 }
      it { expect(response.body).to include("沒有庫存") }
    end
  end

  describe '#update_sheet' do
    context 'when user is admin' do
      let(:user) { create(:user, :admin).tap { |u| u.confirm } }
      let!(:send_request) { post "#{endpoint}/update_sheet?#{messenger_id_params(user)}", params: { sync: 'true' } }

      it { expect(response_status).to eq 200 }
      it { expect(response_body['messages']).not_to be_empty }
      it { assert_enqueued_jobs 1 }
    end

    context 'when user is not admin' do
      let(:user) { create(:user) }

      let!(:send_request) { post "#{endpoint}/update_sheet?#{messenger_id_params(user)}", params: { sync: 'true' } }

      it { expect(response_status).to eq 200 }
      it { expect(response_body['messages']).not_to be_empty }
      it { assert_enqueued_jobs 0 }
    end
  end

  after do
    clear_enqueued_jobs
  end
end