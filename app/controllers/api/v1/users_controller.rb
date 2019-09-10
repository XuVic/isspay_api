class Api::V1::UsersController < Api::V1::BaseController
  include Api::V1::Users::Registration
  include Api::V1::Users::Auth

  prepend_before_action :sanitize_sign_up_params, only: %i(create)

  def confirmation
    user = User.confirm_by_token(confirmation_token)
    result = Result.new(status: 400, body: 'Confirmation token is invalid.')
  
    result = Result.new(status: 200, body: 'Account is confirmed successfully.') if user.confirmed?

    respond_with result
  end

  def confirmation_token
    params.require(:token)
  end
end
