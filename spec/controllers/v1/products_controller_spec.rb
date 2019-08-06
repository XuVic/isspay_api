require 'rails_helper'

Rails.describe Api::V1::ProductsController, type: :request do
  before :all do
    3.times { create(:product, :snack) }
    2.times { create(:product, :drink) }
  end

  describe '#index' do
    let(:request_path) { '/api/v1/products' }

    context 'query_string=nil' do
      it 'list all products' do
        get request_path
        result = JSON.parse(response.body)
        expect(result['data'].size).to eq(5)
      end
    end
  end

  describe '#destroy' do
    before :all do
      @pre_amount = Product.all.size
      @product_id = Product.all.first.id
      delete "/api/v1/products/#{@product_id}"
    end

    it { expect { Product.find(@product_id) }.to raise_error(ActiveRecord::RecordNotFound) }

    it { expect(Product.all.size).to eq(@pre_amount - 1) }
  end
end