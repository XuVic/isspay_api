class ApplicationController < ActionController::Metal
  include AbstractController::Callbacks
  include AbstractController::Caching
  include ActionController::StrongParameters
  include ActiveSupport::Rescuable
  include ActionController::Rescue
  include CanCan::ControllerAdditions
  include JsonRenderHelper

  def sanitize_params
    
  end

  def current_ability
    @_current_ability ||= Abilities::Ability.new(current_user)
  end

  def respond_with(result)
    responder.new(self, result).call
  end

  def respond_with_expectation(expectation, status)
    result = Result.new(status: status, body: expectation.message)
    respond_with result
  end

  def responder
    ApiResponder
  end
end
