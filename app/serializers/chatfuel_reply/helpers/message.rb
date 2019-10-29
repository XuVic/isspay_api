module ChatfuelReply
  module Helpers::Message
    def text(messages)
      messages = messages.map do |msg|
        { text: msg }
      end
    end
    
    def quick_reply(title, options = {})
      type = options[:type] || 'json_plugin_url'
      reply = { title: title }
      reply.merge!(block_names: options[:block_names]) if options[:block_names]
      reply.merge!(url: options[:url]) if options[:url]
      reply.merge!(type: type) if options[:url]
      reply
    end
  end
end