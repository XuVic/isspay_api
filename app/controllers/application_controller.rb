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
