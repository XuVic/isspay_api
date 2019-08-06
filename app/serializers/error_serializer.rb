class ErrorSerializer
  attr_reader :errors
  
  def initialize(errors)
    @errors = errors
  end

  def serializable
    error_messages
  end

  def error_messages
    @errors.full_messages
  end
end