module ChatfuelReply
  class Reply
    include Helpers::All

    attr_reader :user, :body

    def initialize(user)
      @user = user
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

    def messenger_id
      user ? user.messenger_id : ''
    end

    def set_reply_body(body)
      @body = body
    end
  end
end