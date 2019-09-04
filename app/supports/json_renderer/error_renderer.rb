module JsonRenderer
  class ErrorRenderer < Renderer
    
    private

    def data
      if errors_object?
        body.full_messages.uniq
      elsif error_messages?
        body
      end
    end

    def errors_object?
      body.is_a?(ActiveModel::Errors)
    end

    def error_messages?
      body.is_a?(String) || body[0].is_a?(String)
    end

    def type
      'error'
    end

  end
end