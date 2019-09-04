require 'rails_helper'

Rails.describe Api::V1::ProductsController, type: :request do
  before :all do
    @prev_products = Product.all.size
    3.times { create(:product, :snack) }
    2.times { create(:product, :drink) }
    @user = create(:user)
    @admin = create(:user, :admin)
    @token = create_token(@user)
    @admin_token = create_token(@admin)
  end

  describe '#index' do
    context 'query_string=nil' do
      before :all do
        get '/api/v1/products', headers: { Authorization: "Bearer #{@token}" }
        @response_body = JSON.parse(response.body)
      end

      it { expect(@response_body['data'].size).to eq(@prev_products + 5) }
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

      it { expect(response.status).to eq 201 }
      it { expect(Product.find(@product_id).name).to eq "#{@org_name}_modified" }
      it { expect(Product.find(@product_id).price).to eq @product.price }
    end
  end

  describe '#create' do
    context 'login as admin' do
      before :all do
        @pre_products_size = Product.all.size
        product_attributes = build(:product, :snack).attributes
        product_attributes[:category_id] = Category.first.id
        post '/api/v1/products', headers: { Authorization: "Bearer #{@admin_token}" },
                                 params: { product: product_attributes }
      end

      it { expect(response.status).to eq 201 }
      it { expect(Product.all.size).to eq (@pre_products_size + 1) }
    end
  end
end