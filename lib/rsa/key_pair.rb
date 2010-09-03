module RSA
  ##
  # An RSA key pair.
  #
  # Refer to PKCS #1 v2.1, section 3, pp. 6-8.
  #
  # @see http://www.rsa.com/rsalabs/node.asp?id=2125
  # @see http://en.wikipedia.org/wiki/Public-key_cryptography
  class KeyPair
    ##
    # The RSA private key.
    #
    # @return [Key]
    attr_reader :private_key

    ##
    # The RSA public key.
    #
    # @return [Key]
    attr_reader :public_key

    ##
    # Initializes a new key pair.
    #
    # @param  [Key]                    private_key
    # @param  [Key]                    public_key
    # @param  [Hash{Symbol => Object}] options
    def initialize(private_key, public_key, options = {})
      @private_key = private_key
      @public_key  = public_key
      @options     = options.dup
    end

    ##
    # Returns `true` if this is a valid RSA key pair according to
    # {RSA::PKCS1 PKCS #1}.
    #
    # @return [Boolean]
    # @see    Key#valid?
    def valid?
      private_key.valid? && public_key.valid?
    end
  end # class KeyPair
end # module RSA
