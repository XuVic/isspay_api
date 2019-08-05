require 'rails_helper'

Rails.describe Api::V1::ProductsController, type: :controller do
  describe '#index' do
    context 'query_string=nil' do
      it 'list all products' do
        get :index
        binding.pry
      end
    end
  end
end