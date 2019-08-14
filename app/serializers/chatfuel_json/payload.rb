module ChatfuelJson
  class Payload
    def initialize(elements, type)
      @type = type
      @elements = elements
    end

    def serializable
      to_gallery
    end

    private

    def to_gallery
      {
        template_type: 'generic',
        image_aspect_ratio: 'square',
        elements: @elements
      }
    end
  end
end