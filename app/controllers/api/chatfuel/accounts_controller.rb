module Api::Chatfuel
  class AccountsController < BaseController
    def show
      authorize! :show, current_account
      
      replier.show(current_account)
    end

    def repay
      balance = current_user.balance
      account = AccountRepay.new(user: current_user).call!

      replier.repay(balance, account)
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
