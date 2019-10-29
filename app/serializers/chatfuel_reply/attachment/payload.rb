module ChatfuelReply
  module Attachment
    Payload = Struct.new(:type, :elements) do
      def to_h
        {
          template_type: 'generic',
          image_aspect_ratio: 'square',
          elements: self.elements.map(&:to_h)
        }
      end
    end

    def self.to_h(payload)
      {
        attachment: {
          type: 'template',
          payload: payload.to_h
        }
      }
    end
  end
end