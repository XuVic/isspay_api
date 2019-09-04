class AuthToken
  include Security::Authable
  include Security::Encryptable

  ONE_HOUR = 60 * 60
  ONE_DAY = ONE_HOUR * 24
  ONE_WEEK = ONE_DAY * 7
  ONE_MONTH = ONE_WEEK * 4
  ONE_YEAR = ONE_MONTH * 12
  
  EXPIRES_UNIT = {
    hour: ONE_HOUR,
    day: ONE_DAY,
    week: ONE_WEEK,
    month: ONE_MONTH,
    year: ONE_YEAR
  }

  class ExpiredTokenError < StandardError
    def initialize
      @message = 'Token is expired, please login again.'
      super(@message)
    end
  end
  class InvalidTokenError < StandardError
    def initialize
      @message = 'Token is invalid.'
      super(@message)
    end
  end
  
  class Payload < SimpleDelegator
    def self.deserialize(json_str)
      new(JSON.parse(json_str))
    end

    def initialize(hash)
      super(hash)
    end

    def get_value(key)
      result = self[key.to_sym]

      result = self[key.to_s] unless result

      result.is_a?(Hash) ? Payload.new(result) : result
    end
  end

  class << self
    def create(payload:, expires_options: nil)
      payload = Payload.new(payload)
      payload64 = encode64(payload.to_json)
      message = "#{payload64}.#{expires_date(expires_options)}"
      
      tokenize(message)
    end

    def payload(token)
      payload64, expire_date = detokenize!(token).split('.')

      expired?(expire_date)

      payload_str = decode64(payload64)

      Payload.deserialize(payload_str)
    end

    def expires_in(expires_options)
      return ONE_WEEK unless expires_options

      EXPIRES_UNIT[expires_options[:unit]] * expires_options[:n].to_i
    end

    def expires_date(expires_options)
      (Time.now + expires_in(expires_options)).to_i
    end

    private

    def valid?(token)
      cipher64, nonce64, signature64 = token.split('.')
      message = "#{nonce64}.#{cipher64}"
      signature = decode64(signature64)
      
      raise InvalidTokenError unless verify(message, signature) || signature

    rescue StandardError
      raise InvalidTokenError
    end

    def serialize(payload)
      payload.to_json
    end

    def expired?(expire_date)
      expire_date = expire_date.to_i

      raise ExpiredTokenError if Time.now > Time.at(expire_date)
    end

    def tokenize(message)
      return nil unless message
      
      nonce64 = create_nonce64
      cipher64 = encrypt(nonce64, message)
      new_message = "#{nonce64}.#{cipher64}"
      signature64 = create_digest64(new_message)
      "#{cipher64}.#{nonce64}.#{signature64}"
    end

    def detokenize!(token)
      valid?(token)

      cipher64, nonce64, signature64 = token.split('.')
      decrypt(nonce64, cipher64)
    end
  end
end