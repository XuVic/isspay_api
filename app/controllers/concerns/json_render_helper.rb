module JsonRenderHelper
  extend ActiveSupport::Concern

  attr_reader :options

  def render_json(obj, options = {})
    return nil unless obj

    @options = options
    
    case options[:type]
    when :error
      render_error_json(obj)
    when :resource
      render_resource_json(obj)
    when :message
      set_response_body(obj)
    else
    end
  end

  private

  def set_response_body(serializer)
    set_response_header

    self.response_body = ResponseSerializer.serialize response, serializer, response_options
  end

  def set_response_header
    self.response.set_header('Content-Type', 'application/json; charset=utf-8')
  end

  def response_options
    {
      serializer_type: options[:type]
    }
  end

  def render_resource_json(model_obj)
    response.status = options[:status] ? options[:status] : 200
    model_name = model_obj.respond_to?(:each) ? model_obj[0].model_name.to_s : model_obj.model_name.to_s
    model_serializer = "Resource::#{model_name}Serializer".constantize.new(model_obj)
    set_response_body model_serializer
  end

  def render_error_json(error)
    response.status = options[:status] ? options[:status] : 400
    set_response_body ErrorSerializer.new(error)
  end
end