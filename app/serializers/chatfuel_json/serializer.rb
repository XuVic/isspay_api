module ChatfuelJson
  class Serializer
    include UrlHelper
    include Attachment
    include Message

    attr_reader :messenger_id, :body

    def initialize(messenger_id)
      @messenger_id = messenger_id
      @body = ''
    end

    def to_message
      {
        messages: body
      }.to_json
    end

    def set_msg_body(method, *params)
      if params.nil?
        body = self.send(method)
      else
        body = self.send(method, *params)
      end
    end
  end
end