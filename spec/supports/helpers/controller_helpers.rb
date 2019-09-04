module ControllerHelpers
  def create_token(user)
    auth_request(user)
    response_data['access_token']
  end

  def create_refresh_token(user)
    auth_request(user)
    response_data['refresh_token']
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