Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope module: 'devise' do
        resources :users, only: %i[index update]
        post 'users', to: 'registrations#create'
      end

      resources :products, only: %i[index update create destroy]
    end

    namespace :chatfuel do
      get 'create_transaction', to: 'transactions#create'
      get 'delete_transaction', to: 'transactions#destroy'
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
