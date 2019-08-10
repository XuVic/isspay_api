module Security
  module Encryptable
    extend ActiveSupport::Concern
    include Base

    module ClassMethods
      def create_nonce64(key = nil)
        bytes = create_encryptor(key).nonce_bytes
        nonce = RbNaCl::Random.random_bytes(bytes)

        encode64(nonce)
      end

      def encrypt(nonce64, plaintext, key=nil)
        encryptor = create_encryptor(key)
        nonce = decode64(nonce64)
        ciphertext = encryptor.encrypt(nonce, plaintext)

        encode64(ciphertext)
      end

      def decrypt(nonce64, ciphertext64, key=nil)
        encryptor = create_encryptor(key)
        ciphertext = decode64(ciphertext64)
        nonce = decode64(nonce64)

        encryptor.decrypt(nonce, ciphertext)
      end
      
      private

      def create_encryptor(key = nil)
        key = base_key(32) unless key
      
        RbNaCl::SecretBox.new(key)
      end
    end
  end
end