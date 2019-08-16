module Api::Chatfuel
  class AccountsController < BaseController
    def show
      authorize! :show, current_account
      message = ChatfuelJson::Response.new(resources: [current_account], messenger_id: messenger_id)
      message.body_to(:check_account, fields)

      render_json message
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
