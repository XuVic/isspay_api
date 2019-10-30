module Api::Chatfuel
  class AccountsController < BaseController
    def show
      authorize! :show, current_account
      
      replier.show(current_account)
    end

    def repay
    end

    private

    def fields
      params.require(:fields)
    end

    def current_account
      current_user.account
    end
  end
end
