class JsonResponse
  attr_reader :status, :body, :options

  def initialize(status, body, options={})
    @status = status
    @body = body
    @options = options
  end

  def to_json
    serializer.to_json
  end

  # private

  def serializer
    @serializer ||= resourceful_serializer if resource?
    @serializer ||= error_serializer if error?
    @serializer ||= message_serializer if message?
    @serializer
  end

  def message_serializer
    msg = body
    { messages: msg }
  end

  def error_serializer
    error_msg = body
    error_msg = body.full_messages.uniq if body.is_a?(ActiveModel::Errors)
    { errors: error_msg }
  end

  def resourceful_serializer
    return { data: [] } unless body.present?

    model_name = body.model_name.to_s if body.respond_to?(:model_name)
    model_name = body[0].model_name.to_s if body[0].respond_to?(:model_name)
    klass = "Resource::#{model_name}Serializer".constantize
    klass.new(body)
  end

  def resource?
    options[:type] == :resource
  end

  def error?
    options[:type] == :error
  end

  def message?
    options[:type] == :message
  end
end