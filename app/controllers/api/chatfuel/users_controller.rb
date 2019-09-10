module Api::Chatfuel
  class UsersController < BaseController
    def create
      result = UserForm.in_create(sign_up_resource).submit
  
      if result.success?
        msg = "恭喜 #{result.body.name}，成功註冊 IssPay～～"
        message = ChatfuelJson::Response.new(messages: [msg], messenger_id: messenger_id)
        message.body_to(:text)
        respond_with message
      end
    end

    private
    def sign_up_params
      sanitize_sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :nick_name, :gender, :role, :messenger_id)
    end

    def sign_up_resource
      build_resource(sign_up_params)
    end

    def sanitize_sign_up_params
      return unless params[:user]
      
      params[:user][:gender] = params[:user][:gender].to_i if params[:user][:gender]
      params[:user][:role] = params[:user][:role].to_i if params[:user][:gender]
    end
  end
end
