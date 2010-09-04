module RSA
  module OpenSSL
    # TODO
  end # module OpenSSL

  class KeyPair
    ##
    # Returns this key pair as an `OpenSSL::PKey::RSA` instance.
    #
    # @return [OpenSSL::PKey::RSA]
    def to_openssl
      @openssl_pkey ||= begin
        pkey   = ::OpenSSL::PKey::RSA::new
        pkey.n = private_key.modulus  if private_key?
        pkey.e = private_key.exponent if private_key?
        pkey.n ||= public_key.modulus if public_key?
        pkey.d = public_key.exponent  if public_key?
        pkey
      end
    end
  end
end # module RSA
