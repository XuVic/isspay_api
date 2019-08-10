class ErrorSerializer
  attr_reader :errors
  
  def initialize(errors)
    @errors = errors
  end

  def serializable
    error_messages
  end

  def error_messages
    return errors if errors.is_a?(Array) || errors.is_a?(String)

    @errors.full_messages
  end
end