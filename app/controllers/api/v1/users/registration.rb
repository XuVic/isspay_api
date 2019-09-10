module Api::V1::Users
  module Registration
    def create
      result = UserForm.in_create(sign_up_resource).submit

      respond_with result
    end

    private
    def sign_up_params
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
