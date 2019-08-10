class LoginForm < BaseForm
  delegate :email, :password, to: :resource 

  def valid?
    errors.add(:base, :credentials_invalid, message: "Credentials is not valid.") if credential_invalid?
    errors.full_messages.empty?
  end

  def submit
    if valid?
      authenticated_user
    else
      errors
    end
  end

  def credential_invalid?
    authenticated_user.nil?
  end

  def authenticated_user
    @_authenticated_user ||= User.authenticate(email: email, password: password)
  end
end