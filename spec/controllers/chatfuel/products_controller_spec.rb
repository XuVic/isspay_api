require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::ProductsController, type: :request do
  before :all do
    5.times { create(:product, :snack) }
    5.times { create(:product, :drink, quantity: 0) }
  end

  let(:messenger_id) { create(:user).messenger_id }
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
end