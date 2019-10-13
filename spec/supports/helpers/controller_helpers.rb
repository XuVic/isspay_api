module ControllerHelpers
  def auth_header(token)
    { Authorization: "Bearer #{token}" }
  end

  def create_confirmed_user(role = 0)
    user = create(:uesr, role: role)
    user.confirm
    user
  end

  def create_user_token
    user = create(:user)
    user.confirm
    create_token(user)
  end

  def create_admin_token
    admin = create(:user, :admin)
    admin.confirm
    create_token(admin)
  end

  def create_token(user)
    auth_request(user)
    response_body['messages']['access_token']
  end

  def create_refresh_token(user)
    auth_request(user)
    response_body['messages']['refresh_token']
  end

  def response_body
    JSON.parse(response.body)
  end

  def response_data
    response_body['data']
  end

  def response_type
    response_body['type']
  end

  def response_status
    response.status
  end

  private

  def auth_request(user)
    post '/api/v1/users/auth', params: { user: { email: user.email, password: user.password } }
  end
end