module Security
  module Authable
    extend ActiveSupport::Concern
    include Base

    module ClassMethods
      def create_digest64(message, key=nil)
        key = base_key(32) unless key

        hash_value = RbNaCl::HMAC::SHA256.auth(key, message)
        encode64(hash_value)
      end

      def verify(digest64, message, key=nil)
        key = base_key(32) unless key

        digest = decode64(digest64)
        RbNaCl::HMAC::SHA256.auth(key, digest, message)
      rescue
        false
      end
    end
  end
end