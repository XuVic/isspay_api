class ApplicationController < ActionController::Metal
  include AbstractController::Callbacks
  include AbstractController::Caching
  include ActionController::StrongParameters
  include RenderHelper

  private
  def build_resource(params)
    model = find_model
    model.new(params)
  end

  def find_model
    self.controller_name.classify.constantize
  end
end
