module ChatfuelReply
  class Reply
    include Message
    include UrlHelper

    attr_reader :messenger_id, :body

    def initialize(messenger_id)
      @messenger_id = messenger_id
      @body = []
    end

    def to_json
      {
        messages: body
      }.to_json
    end

    def send_messages(messages)
      set_reply_body text(messages)
    end

    private

    def set_reply_body(body)
      @body = body
    end
  end
end