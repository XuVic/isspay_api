module Api::Chatfuel
  class BaseController < ApplicationController
    def current_user
      User.find_by_messenger_id(messenger_id)
    end

    private
    
    def render_json(body)
      response.status = 200
      self.response_body = body.to_message
    end

    def messenger_id
      params.require(:user).permit(:messenger_id)['messenger_id']
    end
  end
end
