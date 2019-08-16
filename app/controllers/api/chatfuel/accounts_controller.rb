module Api::Chatfuel
  class AccountsController < BaseController
    def show
      authorize! :show, current_account
      binding.pry
    end

    def repay
    end

    private

    def fields
      params.require(:fields)
    end

    def messenger_id
      params.require(:messenger_id)
    end

    def current_account
      current_user.account
    end
  end
end
