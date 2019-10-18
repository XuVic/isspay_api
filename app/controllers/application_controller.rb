class ApplicationController < ActionController::Metal
  include AbstractController::Callbacks
  include ActionController::StrongParameters
  include ActionController::Rescue
  include CanCan::ControllerAdditions
  include ActionController::ConditionalGet
  include ErrorsHandler
  include Sanitizer

  def current_ability
    @_current_ability ||= Abilities::Ability.new(current_user)
  end

  def render_json(json_response)
    response.status = json_response.status
    self.response_body = json_response.to_json
  end
end
