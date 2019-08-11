require 'rails_helper'

Rails.describe Api::V1::ProductsController, type: :request do
  before :all do
    3.times { create(:product, :snack) }
    2.times { create(:product, :drink) }
    @user = create(:user)
    @admin = create(:user, :admin)
    post '/api/v1/users/auth', params: { user: { email: @user.email, password: @user.password } }
    @token = JSON.parse(response.body)['message']['access_token']
    post '/api/v1/users/auth', params: { user: { email: @admin.email, password: @admin.password } }
    @admin_token = JSON.parse(response.body)['message']['access_token']
  end

  describe '#index' do
    context 'query_string=nil' do
      before :all do
        get '/api/v1/products', headers: { Authorization: "Bearer #{@token}" }
        @response_body = JSON.parse(response.body)
      end

      it { expect(@response_body['resource'].size).to eq(5) }
    end
  end

  describe '#destroy' do
    context 'login as admin' do
      before :all do
        @pre_amount = Product.all.size
        @product_id = Product.all.first.id
        delete "/api/v1/products/#{@product_id}", headers: { Authorization: "Bearer #{@admin_token}" }
      end
  
      it { expect(response.status).to eq 200 }
      it { expect { Product.find(@product_id) }.to raise_error(ActiveRecord::RecordNotFound) }
      it { expect(Product.all.size).to eq(@pre_amount - 1) }
    end

    context 'login as normal user' do
      before :all do
        @pre_amount = Product.all.size
        @product_id = Product.all.first.id
        delete "/api/v1/products/#{@product_id}", headers: { Authorization: "Bearer #{@token}" }
      end

      it { expect(response.status).to eq 403 }
      it { expect(Product.find(@product_id)).not_to be nil }
    end
  end

  describe '#update' do
    context 'login as admin' do
      before :all do
        @product = Product.all.first
        @org_name = @product.name
        @product_id = @product.id
        put "/api/v1/products/#{@product_id}", headers: { Authorization: "Bearer #{@admin_token}" }, 
                               params: { product: { name: "#{@product.name}_modified" } }
      end

      it { expect(response.status).to eq 200 }
      it { expect(Product.find(@product_id).name).to eq "#{@org_name}_modified" }
    end
  end
end