class LoginForm < BaseForm
  delegate :email, :password, to: :target_resource 

  def initialize(resource)
    @resource = resource
  end

  def target_resource
    @resource
  end

  def valid?
    errors.add(:base, :credentials_invalid, message: "Credentials is not valid.") if credential_invalid?
    errors.full_messages.empty?
  end

  def submit
    if valid?
      Result.new(status: 200, body: token_payload)
    else
      Result.new(status: 401, body: errors)
    end
  end

  def credential_invalid?
    authenticated_user.nil?
  end

  def authenticated_user
    @_authenticated_user ||= User.authenticate(email: email, password: password)
  end

  private

  def token_payload
    access_payload = { user_id: authenticated_user.id, role: authenticated_user.role }
    access_token = AuthToken.create payload: access_payload, expires_options: { unit: :month, n: 1}

    refresh_payload = { user_id: authenticated_user.id, refresh: 'allowed' }
    refresh_token = AuthToken.create payload: refresh_payload, expires_options: { unit: :month, n: 3 }

    {
      access_token: access_token,
      refresh_token: refresh_token,
      token_type: 'Bearer',
      expires_date: Time.at(AuthToken.expires_date(unit: :month, n: 1))
    }
  end
end