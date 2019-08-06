module Api::V1::User
  module Registration


    def create
      result = SignUpForm.new(sign_up_resource).submit
      render result
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
