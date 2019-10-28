class LoginForm < Form
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

  def submit!
    raise FormInvalid.new(errors) unless valid?

    authenticated_user
  end

  def credential_invalid?
    authenticated_user.nil?
  end

  def authenticated_user
    @_authenticated_user ||= User.authenticate(email: email, password: password)
  end
end