class AuthToken
  include Security::Authable
  include Security::Encryptable

  ONE_HOUR = 60 * 60
  ONE_DAY = ONE_HOUR * 24
  ONE_WEEK = ONE_DAY * 7
  ONE_MONTH = ONE_WEEK * 4
  ONE_YEAR = ONE_MONTH * 12

  class ExpiredTokenError < StandardError; end
  class InvalidTokenError < StandardError; end
  
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
    def create(payload:, expires_in: ONE_WEEK)
      payload = Payload.new(payload)
      payload64 = encode64(payload.to_json)
      message = "#{payload64}.#{expire_date(expires_in)}"
      tokenize(message)
    end

    def payload(token)
      payload64, expire_date = detokenize(token).split('.')

      expired?(expire_date)

      payload_str = decode64(payload64)

      Payload.deserialize(payload_str)
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

    def expire_date(expires_in)
      expires_in = expires_in.to_i

      (Time.now + expires_in).to_i
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

    def detokenize(token)
      valid?(token)

      cipher64, nonce64, signature64 = token.split('.')
      decrypt(nonce64, cipher64)
    end
  end
end