module JsonRenderHelper
  extend ActiveSupport::Concern

  attr_reader :options

  def render_resources(model_obj, status)
    response.status = status
    
    model_name = model_obj.respond_to?(:each) ? model_obj[0].model_name.to_s : model_obj.model_name.to_s
    model_serializer = "Resource::#{model_name}Serializer".constantize.new(model_obj)
    
    set_response_body model_serializer
  end

  def render_messages(messages, status)
    response.status = status

    set_response_body messages
  end

  def redner_errors(errors, status)
    response.status = status

    set_response_body ErrorSerializer.new(errors)
  end

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
end