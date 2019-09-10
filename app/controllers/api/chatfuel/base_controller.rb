module Api::Chatfuel
  class BaseController < ApplicationController
    def current_user
      User.find_by_messenger_id(messenger_id)
    end

    private
    
    def respond_with(body)
      response.status = 200
      self.response_body = body.to_message
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
  end
end
