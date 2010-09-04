module RSA
  module OpenSSL
    # TODO
  end # module OpenSSL

  class KeyPair
    ##
    # Generates a new RSA key pair of length `bits`.
    #
    # By default, the public exponent will be 65537 (0x10001) as recommended
    # by {RSA::PKCS1 PKCS #1}.
    #
    # @param  [Integer, #to_i] bits
    # @param  [Integer, #to_i] exponent
    # @return [KeyPair]
    def self.generate(bits, exponent = 65537)
      pkey = ::OpenSSL::PKey::RSA.generate(bits.to_i, exponent.to_i)
      n, d, e = pkey.n.to_i, pkey.d.to_i, pkey.e.to_i
      self.new(Key.new(n, d), Key.new(n, e))
    end

    ##
    # Returns this key pair as an `OpenSSL::PKey::RSA` instance.
    #
    # @return [OpenSSL::PKey::RSA]
    def to_openssl
      @openssl_pkey ||= begin
        pkey   = ::OpenSSL::PKey::RSA.new
        pkey.n = private_key.modulus  if private_key?
        pkey.e = private_key.exponent if private_key?
        pkey.n ||= public_key.modulus if public_key?
        pkey.d = public_key.exponent  if public_key?
        pkey
      end
    end
  end # class KeyPair
end # module RSA
