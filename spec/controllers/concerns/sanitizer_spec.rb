require 'rails_helper'

class MockController
  include Sanitizer

  sanitizer_rules do
   clean :age, with: :to_i
   clean :price, create: :to_i, index: -> (price) { price.split(':').map(&:to_i) }
   clean :amount, with: :to_i
   clean :category, with: -> (name) { Category.where(name: name).first!.id }
  end
end

RSpec.describe "Sanitizer Module" do
  let(:category) { create(:category, name: 'snack') }
  let(:base_params) { { user: { age: '18', gender: 'female' }, product: { price: '50', amount: '100', category: category.name }, action: 'create'} }
  
  it { binding.pry }

  # describe '#sanitize' do
  #   context 'some params have clean rule, but some have not ' do
  #     let(:params) { ActionController::Parameters.new(base_params) }
  #     let!(:santiize) { MockController.new.sanitize(params) }

  #     it { expect(params[:user][:age]).to eq 18 }
  #     it { expect(params[:product][:price]).to eq 50 }
  #     it { expect(params[:product][:amount]).to eq 100 }
  #     it { expect(params[:product][:category]).to eq category.id }
  #     it { expect(params[:user][:gender]).to eq 'female' }
  #   end
  # end
end