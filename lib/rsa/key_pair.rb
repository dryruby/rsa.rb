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
    # Encrypts the given `plaintext` using the public key from this key
    # pair.
    #
    # @param  [String, Integer]         plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [String]
    def encrypt(plaintext, options = {})
      plaintext = case plaintext
        when Integer      then plaintext
        when String       then PKCS1.os2ip(plaintext)
        when IO, StringIO then PKCS1.os2ip(plaintext.read)
        else raise ArgumentError, plaintext.inspect
      end
      ciphertext = PKCS1.rsaep(public_key, plaintext)
      PKCS1.i2osp(ciphertext, ::Math.log(ciphertext, 256).ceil)
    end

    ##
    # Decrypts the given `ciphertext` using the private key from this key
    # pair.
    #
    # @param  [String, Integer]         ciphertext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [String]
    def decrypt(ciphertext, options = {})
      ciphertext = case ciphertext
        when Integer      then ciphertext
        when String       then PKCS1.os2ip(ciphertext)
        when IO, StringIO then PKCS1.os2ip(ciphertext.read)
        else raise ArgumentError, ciphertext.inspect
      end
      plaintext = PKCS1.rsadp(private_key, ciphertext)
      PKCS1.i2osp(plaintext, ::Math.log(plaintext, 256).ceil)
    end

    ##
    # Signs the given `plaintext` using the private key from this key pair.
    #
    # @param  [String, Integer]         plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [String]
    def sign(plaintext, options = {})
      plaintext = case plaintext
        when Integer      then plaintext
        when String       then PKCS1.os2ip(plaintext)
        when IO, StringIO then PKCS1.os2ip(plaintext.read)
        else raise ArgumentError, plaintext.inspect
      end
      signature = PKCS1.rsasp1(private_key, plaintext)
      PKCS1.i2osp(signature, ::Math.log(signature, 256).ceil)
    end
  end # class KeyPair
end # module RSA
