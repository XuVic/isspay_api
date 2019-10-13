module Api::V1::Users
  module Auth
    def create_token
      user = refresh_token.empty? ? LoginForm.new(login_resource).submit! : find_user!(refresh_token)

      render_json JsonResponse.new(200, token_payload(user), type: :message)
    end

    private

    def refresh_token
      params.permit(:refresh_token)
    end

    def login_params
      params.require(:user).permit(:email, :password)
    end

    def find_user!(refresh_token)
      payload = AuthToken.payload(refresh_token['refresh_token'])
      user_id = payload['refresh'] == 'allowed' ? payload['user_id'] : ''
      User.find(user_id) 
    end

    def login_resource
      build_resource(login_params)
    end

    def token_payload(user)
      access_payload = { user_id: user.id, role: user.role }
      access_token = AuthToken.create payload: access_payload, expires_options: { unit: :month, n: 1}
  
      refresh_payload = { user_id: user.id, refresh: 'allowed' }
      refresh_token = AuthToken.create payload: refresh_payload, expires_options: { unit: :month, n: 3 }
  
      {
        access_token: access_token,
        refresh_token: refresh_token,
        token_type: 'Bearer',
        admin: user.admin,
        expires_date: Time.at(AuthToken.expires_date(unit: :month, n: 1))
      }
    end
  end
end