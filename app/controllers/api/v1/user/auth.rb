module Api::V1::User
  module Auth
    def create_token
      result = LoginForm.new(login_resource).submit

      respond_with result
    end

    private

    def login_params
      params.require(:user).permit(:email, :password)
    end

    def login_resource
      build_resource(login_params)
    end
  end
end