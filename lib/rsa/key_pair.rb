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
    attr_reader  :private_key
    alias_method :private, :private_key

    ##
    # The RSA public key.
    #
    # @return [Key]
    attr_reader  :public_key
    alias_method :public, :public_key

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
    # Returns `true` if this key pair contains a private key.
    #
    # @return [Boolean]
    def private_key?
      !!private_key
    end
    alias_method :private?, :private_key? # for OpenSSL compatibility

    ##
    # Returns `true` if this key pair contains a public key.
    #
    # @return [Boolean]
    def public_key?
      !!public_key
    end
    alias_method :public?, :public_key?   # for OpenSSL compatibility

    ##
    # Returns `true` if this is a valid RSA key pair according to
    # {RSA::PKCS1 PKCS #1}.
    #
    # @return [Boolean]
    # @see    Key#valid?
    def valid?
      private_key.valid? && public_key.valid?
    end

    ##
    # Returns the byte size of this key pair.
    #
    # @return [Integer]
    def bytesize
      Math.log256(modulus).ceil
    end

    ##
    # Returns the bit size of this key pair.
    #
    # @return [Integer]
    def bitsize
      Math.log2(modulus).ceil
    end
    alias_method :size, :bitsize

    ##
    # Returns the RSA modulus for this key pair.
    #
    # @return [Integer]
    def modulus
      private_key ? private_key.modulus : public_key.modulus
    end
    alias_method :n, :modulus

    ##
    # Encrypts the given `plaintext` using the public key from this key
    # pair.
    #
    # @param  [Integer, String, IO]     plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [Integer]
    def encrypt(plaintext, options = {})
      PKCS1.rsaep(public_key, convert_to_integer(plaintext))
    end

    ##
    # Decrypts the given `ciphertext` using the private key from this key
    # pair.
    #
    # @param  [Integer, String, IO]     ciphertext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [Integer]
    def decrypt(ciphertext, options = {})
      PKCS1.rsadp(private_key, convert_to_integer(ciphertext))
    end

    ##
    # Signs the given `plaintext` using the private key from this key pair.
    #
    # @param  [Integer, String, IO]     plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [Integer]
    def sign(plaintext, options = {})
      PKCS1.rsasp1(private_key, convert_to_integer(plaintext))
    end

    ##
    # Verifies the given `signature` using the public key from this key
    # pair.
    #
    # @param  [Integer, String, IO]     signature
    # @param  [Integer, String, IO]     plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [Boolean]
    def verify(signature, plaintext, options = {})
      PKCS1.rsavp1(public_key, convert_to_integer(signature)).eql?(convert_to_integer(plaintext))
    end

  protected

    ##
    # Converts the given `input` to an integer suitable for use with RSA
    # primitives.
    #
    # @param  [Integer, String, IO] input
    # @return [Integer]
    def convert_to_integer(input)
      case input
        when Integer      then input
        when String       then PKCS1.os2ip(input)
        when IO, StringIO then PKCS1.os2ip(input.read)
        else raise ArgumentError, input.inspect # FIXME
      end
    end
  end # class KeyPair
end # module RSA
