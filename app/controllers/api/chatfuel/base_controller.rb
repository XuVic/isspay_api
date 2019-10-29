module Api::Chatfuel
  class BaseController < ApplicationController
    rescue_from CanCan::AccessDenied, with: :forbidden
    rescue_from ActiveRecord::RecordNotFound, with: :forbidden
    rescue_from Form::InputInvalid, with: :form_invalid
    
    after_action :render_reply

    def current_user
      @_current_user ||= User.where(messenger_id: messenger_id).first
      return @_current_user
      raise CanCan::AccessDenied if @_current_user.nil?
    end

    private
    def forbidden
      message = @_current_user.nil? ? '請先註冊' : '沒有權限'
      replier.send_messages([message])
      render_reply
    end

    def form_invalid(e)
      replier.send_messages(e.error_msgs)
      render_reply
    end

    def render_reply
      response.status = 200
      self.response_body = replier.to_json
    end

    def build_resource(params)
      model = find_model
      model.new(params)
    end
  
    def find_model
      self.controller_name.classify.constantize
    end

    def messenger_id
      params.require(:user)[:messenger_id] 
    end

    def replier
      reply_class = "ChatfuelReply::#{controller_name.capitalize}Reply".constantize
      @_current_user ||= User.where(messenger_id: messenger_id).first
      @_replier ||= reply_class.new(@_current_user)
    end
  end
end
