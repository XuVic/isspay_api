require 'rails_helper'

Rails.describe Api::V1::ProductsController, type: :request do
  before :all do
    3.times { create(:product, :snack) }
    2.times { create(:product, :drink) }
  end

  let(:endpoint) { '/api/v1/products' }
  let(:token) { create_user_token }
  let(:admin_token) { create_admin_token }

  describe '#index' do
    context 'when login as normal user' do
      context 'and query_string is nil' do
        let!(:send_request) { get endpoint, headers: auth_header(token) }
        
        it { expect(response_status).to eq 200 }
        it { expect(response_data.size).to eq Product.all.size }
      end

      context 'and query_string has category' do
        let(:query_string) { "?category=#{Category.first.name}" }
        let!(:send_request) { get endpoint + query_string, headers: auth_header(token) }

        it { expect(response_status).to eq 200 }
        it { expect(response_data.size).to eq Product.where(category_id: Category.first.id).all.size }
      end

      context 'and query_string has price range and quantity range' do
        let(:query_string) { "?price=:100&quantity=5:" }
        let!(:send_request) { get endpoint + query_string, headers: auth_header(token) }
        let(:filtered_products) { Product.where("price <= 100 and quantity >= 5") }

        it { expect(response_status).to eq 200 }
        it { expect(response_data.size).to eq filtered_products.size }
      end
    end

    context 'when request without token' do
      let!(:send_request) { get endpoint }

      it { expect(response_status).to eq 403 }
    end
  end

  describe '#destroy' do
    context 'when login as admin' do
      context 'and product exist in database' do
        let(:product_id) { Product.first.id }
        let!(:send_request) { delete "#{endpoint}/#{product_id}", headers: auth_header(admin_token) }

        it { expect(response_status).to eq 200 }
        it { expect { Product.find(@product_id) }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context 'and product cannot be found' do
        let(:product_id) { 'error' }  
        let!(:send_request) { delete "#{endpoint}/#{product_id}", headers: auth_header(admin_token) }

        it { expect(response_status).to eq 404 }
      end
    end

    context 'when login as normal user' do
      let(:product_id) { Product.first.id }
      let!(:send_request) { delete "#{endpoint}/#{product_id}", headers: auth_header(token) }

      it { expect(response_status).to eq 403 }
      it { expect(Product.find(product_id)).not_to be nil }
    end
  end

  describe '#update' do
    let(:product) { Product.first }
    let(:params) { { product: { name: "#{product.name}_modified" } } }

    context 'when login as admin' do
      let!(:send_request) { put "#{endpoint}/#{product.id}", headers: auth_header(admin_token),
                                                             params: params }
                                                             
      it { expect(response_status).to eq 201 }
      it { expect(Product.find(product.id).name).to include '_modified' }
      it { expect(Product.find(product.id).price).to eq product.price }
    end

    context 'when login as normal user' do
      let!(:send_request) { put "#{endpoint}/#{product.id}", headers: auth_header(token),
                                                             params: params }
                                                             
      it { expect(response_status).to eq 403 }
    end
  end

  describe '#create' do
    let(:product_attr) { build(:product).attributes.tap { |attr| attr['category_id'] = Category.first.id; attr['name'] = 'Test' } }

    context 'when login as admin' do
      
      context 'and sumbit data is valid' do
        let!(:send_request) { post endpoint, headers: auth_header(admin_token),
                                             params: { product: product_attr } }

        it { expect(response_status).to eq 201 }
        it { expect(Product.where(id: response_data['id']).exists?).to be true }
      end

      context 'and product qunatity is lower than zero' do
        let(:invalid_attr) { product_attr.tap { |attr| attr['quantity'] = -1 } }
        let!(:send_request) { post endpoint, headers: auth_header(admin_token),
                                             params: { product: invalid_attr } }
        
        it { expect(response_status).to eq 406 }
      end

      context 'and submit data is empty' do
        let!(:send_request) { post endpoint, headers: auth_header(admin_token) }
        
        it { expect(response_status).to eq 400 }
      end
    end

    context 'when login as normal user' do
      let!(:send_request) { post endpoint, headers: auth_header(token),
                                           params: { product: product_attr } }

      it { expect(response_status).to eq 403 }
    end
  end
end