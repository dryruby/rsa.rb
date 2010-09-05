module RSA
  ##
  # An RSA public or private key.
  #
  # Refer to PKCS #1 v2.1, section 3, pp. 6-8.
  #
  # @see http://www.rsa.com/rsalabs/node.asp?id=2125
  # @see http://en.wikipedia.org/wiki/Public-key_cryptography
  class Key
    ##
    # The RSA modulus, a positive integer.
    #
    # @return [Integer]
    attr_reader  :modulus
    alias_method :n, :modulus

    ##
    # The RSA public or private exponent, a positive integer.
    #
    # @return [Integer]
    attr_reader  :exponent
    alias_method :e, :exponent
    alias_method :d, :exponent

    ##
    # Initializes a new key.
    #
    # @param  [Integer, #to_i]         modulus
    # @param  [Integer, #to_i]         exponent
    # @param  [Hash{Symbol => Object}] options
    def initialize(modulus, exponent, options = {})
      @modulus  = modulus.to_i
      @exponent = exponent.to_i
      @options  = options.dup
    end

    ##
    # Returns `true` if this is a valid RSA key according to {RSA::PKCS1
    # PKCS #1}.
    #
    # @return [Boolean]
    def valid?
      true # TODO: PKCS #1 v2.1, sections 3.1 and 3.2, pp. 6-7.
    end

    ##
    # Returns a two-element array containing the modulus and exponent.
    #
    # @return [Array]
    def to_a
      [modulus, exponent]
    end
  end # class Key
end # module RSA
