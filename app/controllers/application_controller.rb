class ApplicationController < ActionController::Metal
  include AbstractController::Callbacks
  include AbstractController::Caching
  include ActionController::StrongParameters
  include JsonRenderHelper
end
