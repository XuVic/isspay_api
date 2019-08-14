module ChatfuelJson
  class Response
    include Attachment
    include Message

    attr_reader :messages, :resources, :type, :messenger_id

    def initialize(options = {})
      @messages = options[:messages]
      @resources = options[:resources]
      @type = options[:type]
      @messenger_id = options[:messenger_id]
      @body = ''
    end

    def to_message
      {
        messages: @body
      }.to_json
    end

    def body_to(method)
      @body = self.send(method)
    end
  end
end