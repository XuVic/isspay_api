class Api::V1::BaseController < ApplicationController
  rescue_from AuthToken::InvalidTokenError, with: :unauthorized
  rescue_from CanCan::AccessDenied, with: :permission_denied

  private

  def unauthorized
    response.set_header('Authenticate', "Bearer realm='Access to the #{Rails.env} site'")
    error_message = ['Please get the access token.']
    render_json error_message, { type: :error, status: 401 }
  end

  def permission_denied(expectation)
    render_json expectation.message, { type: :error, status: 403 } 
  end

  def current_ability
    @_current_ability ||= Abilities::Ability.new(current_user)
  end

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

  def render_form_result(form_result, options = {})
    if error?(form_result)
      render_json form_result, options.merge({type: :error})
    elsif resource?(form_result)
      render_json form_result, options.merge({type: :resource})
    end
  end

  def error?(obj)
    obj.is_a?(ActiveModel::Errors)
  end

  def resource?(obj)
    if obj.respond_to?(:each)
      obj[0].is_a?(ActiveRecord::Base)
    else
      obj.is_a?(ActiveRecord::Base)
    end
  end
end
