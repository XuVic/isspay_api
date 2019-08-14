require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::ProductsController, type: :request do
  before :all do
    user = create(:user)
    user.save
    @messenger_id = user.messenger_id
    create(:category, name: 'drink')
    create(:product, :snack)
  end
  
  describe '#index' do
    context 'has products' do
      before :all do
        query_str = "user[messenger_id]=#{@messenger_id}&product[category]=snack"
        get "/api/chatfuel/products?#{query_str}"
        @snacks = Product.find_by_category('snack')
        @response_body = Hash.symbolize(JSON.parse(response.body))
        @template = Hash.symbolize(gallery_template)
      end
  
      it { expect(response.status).to eq 200 }
      it { expect(@response_body.same_key_structure? @template).to be true  }
    end

    context 'has no products' do
      before :all do
        query_str = "user[messenger_id]=#{@messenger_id}&product[category]=drink"
        get "/api/chatfuel/products?#{query_str}"
        @snacks = Product.find_by_category('snack')
      end

      it { expect(response.status).to eq 200 }
      it { expect(response.body).to include("沒有庫存") }
    end
  end
end