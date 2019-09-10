module Api::Chatfuel
  class UsersController < BaseController
    def create
      result = CreateUser.new(sign_up_params).call
      
      msg = result.error_messages if result.failure?

      msg = ["恭喜 #{result.body.name}，成功註冊 IssPay～～", "請到 #{result.body.email} 信箱收取驗證信"] if result.success?

      message = ChatfuelJson::Response.new(messages: msg, messenger_id: messenger_id)
      message.body_to(:text)
      respond_with message
    end

    private
    def sign_up_params
      sanitize_sign_up_params
      params.require(:user).permit(:email, :first_name, :last_name, :nick_name, :gender, :role, :messenger_id)
    end

    def sanitize_sign_up_params
      return unless params[:user]
      
      params[:user][:gender] = params[:user][:gender].to_i if params[:user][:gender]
      params[:user][:role] = params[:user][:role].to_i if params[:user][:gender]
    end
  end
end
