module RenderHelper
  extend ActiveSupport::Concern
  
  def render(obj, options = {})
    return nil unless obj

    if error?(obj)
      render_error(obj)
    elsif model?(obj)
      render_resource(obj)
    end
  end

  private

  def set_response_body(serializer, options)
    self.response_body = ResponseSerializer.serialize response, serializer, options
  end

  def render_resource(model_obj)
    response.status = 200
    model_name = model_obj.respond_to?(:each) ? model_obj[0].model_name.to_s : model_obj.model_name.to_s
    model_serializer = "Resource::#{model_name}Serializer".constantize.new(model_obj)
    set_response_body model_serializer, { serializer_type: :resource }
  end

  def render_error(error)
    response.status = 400
    set_response_body ErrorSerializer.new(error), { serializer_type: :error }
  end

  def error?(obj)
    obj.is_a?(ActiveModel::Errors)
  end

  def model?(obj)
    if obj.respond_to?(:each)
      obj[0].is_a?(ActiveRecord::Base)
    else
      obj.is_a?(ActiveRecord::Base)
    end
  end
end