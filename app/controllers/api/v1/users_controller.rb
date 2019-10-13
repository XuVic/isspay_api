class Api::V1::UsersController < Api::V1::BaseController
  include Api::V1::Users::Registration
  include Api::V1::Users::Auth

  prepend_before_action :sanitize_sign_up_params, only: %i(create)

  def confirmation
    user = User.confirm_by_token(confirmation_token)

    json_response = if user.confirmed?
      JsonResponse.new(200, 'Account is confirmed successfully.', type: :message)
    else
      JsonResponse.new(400, ['Confirmation token is invalid.'], type: :error)
    end

    render_json json_response
  end

  def confirmation_token
    params.require(:token)
  end
end
