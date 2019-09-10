module Api::V1::Users
  module Auth
    def create_token
      result = LoginForm.new(login_resource).submit

      respond_with result
    end

    private

    def refresh_token
      params.permit(:refresh_token)
    end

    def login_params
      params.require(:user).permit(:email, :password)
    end

    def login_resource
      unless refresh_token.empty?
        payload = AuthToken.payload(refresh_token['refresh_token'])
        if payload['refresh'] == 'allowed'
          return User.find(payload['user_id'])
        end
      end

      build_resource(login_params)
    end
  end
end