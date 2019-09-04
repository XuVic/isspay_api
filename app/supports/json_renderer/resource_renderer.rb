module JsonRenderer
  class ResourceRenderer < Renderer
    
    ARG_ERROR = 'Argument should be a resource or collection of resources.'
    
    def render
      raise ArgumentError.new(ARG_ERROR) unless is_resources?

      super()
    end

    private

    def is_resources?
      body.is_a?(ActiveRecord::Base) || body[0].is_a?(ActiveRecord::Base)
    end

    def model_serializer
      model_name = body.respond_to?(:each) ? body[0].model_name.to_s : body.model_name.to_s
      "Resource::#{model_name}Serializer".constantize.new(body)
    end

    def data
      model_serializer.serializable_hash[:data]
    end

    def type
      'resource'
    end
  end
end