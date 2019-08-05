class ApplicationController < ActionController::Metal
  include AbstractController::Callbacks
  include ActionController::StrongParameters
end
