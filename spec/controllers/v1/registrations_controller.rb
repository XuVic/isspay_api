require 'rails_helper'

Rails.describe Api::V1::UsersController, type: :request do
  describe '#create' do
    before(:all) do
      @user_attributes = attributes_for(:user)
      @invalid_attributes = attributes_for(:user).tap {|hash| hash.delete(:email)}
    end
    
    context 'Paramters are all correct' do
      before(:all) do
        post '/api/v1/users', params: { user: @user_attributes }
        @user = User.where(email: @user_attributes[:email])
        @response_body = JSON.parse(response.body)
      end

      it { expect(@user.exists?).to eq true }
      it { expect(@response_body['type']).to eq 'resource' }
      it { expect(@response_body['data']['attributes']['email']).to eq @user_attributes[:email] }
    end

    context 'Parameter are invalid' do
      before(:all) do
        post '/api/v1/users', params: { user: @invalid_attributes }
        @user = User.where(nick_name: @invalid_attributes[:nick_name])
        @response_body = JSON.parse(response.body)
      end

      it { expect(@user.exists?).to eq false }
      it { expect(@response_body['type']).to eq 'error' }
      it { expect(@response_body['error']).to_not be_nil }
    end
  end
end