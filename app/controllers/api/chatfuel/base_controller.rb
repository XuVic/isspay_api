module Api::Chatfuel
  class BaseController < ApplicationController
    rescue_from CanCan::AccessDenied, with: :forbidden
    
    def current_user
      User.find_by_messenger_id(messenger_id)
    end

    private
    def forbidden
      render_msg type: :text, msg: ['沒有權限']
    end

    def render_msg(type:, msg:)
      if serializer.set_msg_body(type, msg)
        response.status = 200
        self.response_body = serializer.to_json
      end
    end

    def build_resource(params)
      model = find_model
      model.new(params)
    end
  
    def find_model
      self.controller_name.classify.constantize
    end

    def messenger_id
      params.require(:user).permit(:messenger_id)['messenger_id']
    end

    def serializer
      @serializer ||= ChatfuelJson::Serializer.new(messenger_id)
    end
  end
end
