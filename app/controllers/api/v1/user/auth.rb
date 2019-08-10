module Api::V1::User
  module Auth
    def create_token
      if error?(@authenticated_result)
        unauthorized
      elsif resource?(@authenticated_result)
        tokenization
      end
    end

    private

    def login_params
      params.require(:user).permit(:email, :password)
    end

    def login_resource
      build_resource(login_params)
    end

    def authenticate_user
      login_form = LoginForm.new(login_resource)
      @authenticated_result = login_form.submit
    end

    def authenticated?
      @authenticated_result.is_a?(User) && @authenticated_result.persisted
    end

    def unauthorized
      render_json @authenticated_result, { type: :error, status: 401 }
    end

    def tokenization
      access_payload = { user_id: @authenticated_result.id, role: @authenticated_result.role }
      access_token = AuthToken.create payload: access_payload, expires_options: { unit: :month, n: 1}

      refresh_payload = { user_id: @authenticated_result.id, refresh: 'allowed' }
      refresh_token = AuthToken.create payload: refresh_payload, expires_options: { unit: :month, n: 3 }

      result = {
        access_token: access_token,
        refresh_token: refresh_token,
        token_type: 'Bearer',
        expires_date: Time.at(AuthToken.expires_date(unit: :month, n: 1))
      }

      render_json result, type: :message
    end
  end
end