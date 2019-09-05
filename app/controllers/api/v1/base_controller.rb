class Api::V1::BaseController < ApplicationController
  rescue_from AuthToken::InvalidTokenError, with: :unauthorized
  rescue_from CanCan::AccessDenied, with: :forbidden
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def current_user
    return @_current_user if @_current_user

    payload = AuthToken.payload(token)
    user_id = payload.get_value('user_id')
    @_current_user = User.find(user_id)
  end

  def build_resource(params)
    model = find_model
    model.new(params)
  end

  def find_model
    self.controller_name.classify.constantize
  end

  def token
    authorization_str = request.get_header('Authorization') || request.get_header('HTTP_AUTHORIZATION')
    return nil unless authorization_str

    standard, token = authorization_str.split(' ')

    standard == 'Bearer' ? token : nil
  end
end
