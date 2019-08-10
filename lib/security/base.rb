module Security
  module Base
    extend ActiveSupport::Concern
    BASE_KEY = Rails.application.secret_key_base
    
    module ClassMethods
      def base_key(bytes=nil)
        return BASE_KEY unless bytes

        bytes = bytes.to_i

        BASE_KEY[0...bytes]
      end

      def encode64(str)
        Base64.strict_encode64(str)
      end

      def decode64(str)
        Base64.strict_decode64(str)
      end
    end
  end
end