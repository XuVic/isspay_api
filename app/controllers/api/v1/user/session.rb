module Api::V1::User
  module Session
    def auth
    end

    def logout
    end

    def test
      response.set_header('Set-Cookie', 'n1=test; n2=test2;')
      self.response_body = "test"
    end

    private

    def login_params
      params.require(:user).permit(:email, :password)
    end

    def authenticate_user
      email = login_params[:email]
      password = login_params[:password]
      @current_user = User.authenticate(email: email, password: password)
    end
  end
end