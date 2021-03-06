Rails.application.routes.draw do
  api_welcome_msg = 'Welcome to use IssPay API with version '
  
  def default_message(message)
    [200, {'Content-Type' => 'text/json'}, [{message: message}.to_json]]
  end

  root to: Proc.new { default_message('Please use /api/v1 to fetch data.') }

  namespace :api do
    namespace :v1 do
      api_welcome_msg += 'one.'

      resources :users, only: %i[index create update] do
        collection do
          post 'auth', to: 'users#create_token'
          get 'confirmation/:token', to: 'users#confirmation'
        end
      end

      resources :products, only: %i[index update create destroy]
      resources :transactions, only: %i[index update create destroy] do
        collection do
          get 'search', to: 'transactions#search'
        end
      end

      root to: Proc.new { default_message(api_welcome_msg) }
    end

    namespace :chatfuel do
      get 'create_transaction', to: 'transactions#create'
      get 'delete_transaction/:id', to: 'transactions#destroy'
      
      scope :accounts do
        get '/', to: 'accounts#show'
        get 'repay', to: 'accounts#repay'
      end

      resources :users, only: %i[create] do
        collection do
          get '/', to: 'users#show'
          post 'set_admin', to: 'users#set_admin'
          post 'update', to: 'users#update'
        end
      end
      resources :products, only: %i[index] do
        collection do
          post 'update_sheet', to: 'products#update_sheet'
        end
      end
    end
  end
end
