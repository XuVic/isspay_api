require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::TransactionsController, type: :request do
  before :all do
    user = create(:user)
    user.save
    @messenger_id = user.messenger_id
    @product = create(:product, :snack)
  end
  
  describe '#create' do
    before :all do
      query_str = "user[messenger_id]=#{@messenger_id}&products[][id]=#{@product.id}&products[][quantity]=1"
      get "/api/chatfuel/create_transaction?#{query_str}"
      @user = User.find_by_messenger_id(@messenger_id)
      @response_body = Hash.symbolize(JSON.parse(response.body))
      @template = Hash.symbolize(transaction_reply)
    end

    it { expect(response.status).to eq 200 }
    it { expect(@user.balance).to eq (0 - @product.price) }
    it { expect(@response_body.same_key_structure? @template ).to be true }
  end

  describe '#destroy' do
  end
end