module ControllerHelpers
  def create_token(user)
    post '/api/v1/users/auth', params: { user: { email: user.email, password: user.password } }
    response_body['data']['access_token']
  end

  def response_body
    JSON.parse(response.body)
  end

  def resource_attributes
    return nil unless response_body['type'] == 'resource'

    if response_body['resource'].is_a?(Hash)
      response_body['resource']['attributes'].keys.sort
    elsif response_body['resource'].is_a?(Array)
      response_body['resource'][0]['attributes'].keys.sort
    end
  end
end