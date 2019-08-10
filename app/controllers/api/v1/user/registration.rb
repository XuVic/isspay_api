module Api::V1::User
  module Registration
    def create
      result = UserForm.new(sign_up_resource, context: :sign_up).submit
      if error?(result)
        render_json result, type: :error
      elsif resource?(result)
        render_json result, type: :resource
      end
      
    end

    private
    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :nick_name, :gender, :role, :messenger_id)
    end

    def sign_up_resource
      build_resource(sign_up_params)
    end

    def sanitize_sign_up_params
      params[:user][:gender] = params[:user][:gender].to_i
      params[:user][:role] = params[:user][:role].to_i
    end
  end
end
