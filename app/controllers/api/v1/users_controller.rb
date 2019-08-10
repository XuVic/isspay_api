class Api::V1::UsersController < Api::V1::BaseController
  include Api::V1::User::Registration
  include Api::V1::User::Session

  prepend_before_action :sanitize_sign_up_params, only: %i(create)
  prepend_before_action :authenticate_user, only: %i(login)
end
