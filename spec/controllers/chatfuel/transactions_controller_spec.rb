require 'rails_helper'

Rails.describe Api::Chatfuel::TransactionsController, type: :request do
  before :all do
    user = create(:user)
    user.credit = 30000
    user.save
    @messenger_id = user.messenger_id
    @product = create(:product, :snack)
  end
  
  describe '#create' do
    before :all do
      query_str = "user[messenger_id]=#{@messenger_id}&products[][id]=#{@product.id}&products[][quantity]=1"
      get "/api/chatfuel/create_transaction?#{query_str}"
    end

    it { }
  end

  describe '#destroy' do
  end
end