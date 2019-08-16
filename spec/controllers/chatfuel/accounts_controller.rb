require 'rails_helper'
require_relative 'templates/init'

Rails.describe Api::Chatfuel::AccountsController, type: :request do
  before :all do
    user = create(:user)
    user.save
    @messenger_id = user.messenger_id
    create(:category, name: 'snack')
    @product = create(:product, :snack)
    user.order([@product], allowed: true)
  end

  describe "#show" do
    context "fields[]=balance" do
      before :all do
        @balance = User.find_by_messenger_id(@messenger_id).balance
        get "/api/chatfuel/accounts/#{@messenger_id}?fields[]=balance"
        binding.pry
      end

      it { expect(response.body).to include @balance.to_s }
    end
    context 'fields[]=consumption' do
      before :all do
        get "/api/chatfuel/accounts/#{@messenger_id}?fields[]=consumption"
      end

      it { expect(response.body).to include @product.price.to_s }
    end
  end
end