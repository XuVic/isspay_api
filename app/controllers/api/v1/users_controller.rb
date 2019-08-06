
class Api::V1::UsersController < Api::V1::BaseController
  include User::Registration

  before_action :sanitize_sign_up_params, only: %i(create)
end
