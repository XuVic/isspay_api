class ApplicationController < ActionController::Metal
  include AbstractController::Callbacks
  include AbstractController::Caching
  include ActionController::StrongParameters
  include ActiveSupport::Rescuable
  include ActionController::Rescue
  include CanCan::ControllerAdditions
  include JsonRenderHelper
end
