class ResponseSerializer

  def self.serialize(response, serializer = nil, options = {})
    serializer = self.new(response, serializer, options)
    serializer.to_json
  end

  attr_reader :options, :serializer, :serializable_hash

  def initialize(response, serializer = nil, options = {})
    @response = response
    @serializer = serializer
    @options = options
    @serializable_hash = {
      status: @response.message
    }
  end

  def to_json
    build_hash
    ActiveSupport::JSON.encode(@serializable_hash)
  end

  def build_hash
    return unless @serializer || options[:serializer_type]

    serializable_hash[:type] = options[:serializer_type].to_s
    case options[:serializer_type]
    when :resource
      serializable_hash[:data] = data_hash
    when :error
      serializable_hash[:error] = error_hash
    when :message
      serializable_hash[:message] = message_hash
    end 
  end

  def data_hash
    serializer.serializable_hash[:data]
  end

  def error_hash
    serializer.serializable
  end

  def message_hash
    serializer
  end
end