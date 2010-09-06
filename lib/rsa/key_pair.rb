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
    # @overload encrypt(plaintext, options = {})
    #   @param  [Integer]                 plaintext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [Integer]
    #
    # @overload encrypt(plaintext, options = {})
    #   @param  [String, IO, StringIO]    plaintext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [String]
    #
    # @param  [Object]                  plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    def encrypt(plaintext, options = {})
      case plaintext
        when Integer      then encrypt_integer(plaintext, options)
        when String       then PKCS1.i2osp(encrypt_integer(PKCS1.os2ip(plaintext), options))
        when StringIO, IO then PKCS1.i2osp(encrypt_integer(PKCS1.os2ip(plaintext.read), options))
        else raise ArgumentError, plaintext.inspect # FIXME
      end
    end

    ##
    # Decrypts the given `ciphertext` using the private key from this key
    # pair.
    #
    # @overload decrypt(ciphertext, options = {})
    #   @param  [Integer]                 ciphertext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [Integer]
    #
    # @overload decrypt(ciphertext, options = {})
    #   @param  [String, IO, StringIO]    ciphertext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [String]
    #
    # @param  [Object]                  ciphertext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    def decrypt(ciphertext, options = {})
      case ciphertext
        when Integer      then decrypt_integer(ciphertext, options)
        when String       then PKCS1.i2osp(decrypt_integer(PKCS1.os2ip(ciphertext), options))
        when StringIO, IO then PKCS1.i2osp(decrypt_integer(PKCS1.os2ip(ciphertext.read), options))
        else raise ArgumentError, ciphertext.inspect # FIXME
      end
    end

    ##
    # Signs the given `plaintext` using the private key from this key pair.
    #
    # @overload sign(plaintext, options = {})
    #   @param  [Integer]                 plaintext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [Integer]
    #
    # @overload sign(plaintext, options = {})
    #   @param  [String, IO, StringIO]    plaintext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [String]
    #
    # @param  [Object]                  plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    def sign(plaintext, options = {})
      case plaintext
        when Integer      then sign_integer(plaintext, options)
        when String       then PKCS1.i2osp(sign_integer(PKCS1.os2ip(plaintext), options))
        when StringIO, IO then PKCS1.i2osp(sign_integer(PKCS1.os2ip(plaintext.read), options))
        else raise ArgumentError, plaintext.inspect # FIXME
      end
    end

    ##
    # Verifies the given `signature` using the public key from this key
    # pair.
    #
    # @overload verify(signature, plaintext, options = {})
    #   @param  [Integer]                 signature
    #   @param  [Integer]                 plaintext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [Boolean]
    #
    # @overload verify(signature, plaintext, options = {})
    #   @param  [String, IO, StringIO]    signature
    #   @param  [String, IO, StringIO]    plaintext
    #   @param  [Hash{Symbol => Object}]  options
    #   @return [Boolean]
    #
    # @param  [Object]                  signature
    # @param  [Object]                  plaintext
    # @param  [Hash{Symbol => Object}]  options
    # @option options [Symbol, #to_sym] :padding (nil)
    # @return [Boolean]
    def verify(signature, plaintext, options = {})
      signature = case signature
        when Integer      then signature
        when String       then PKCS1.os2ip(signature)
        when StringIO, IO then PKCS1.os2ip(signature.read)
        else raise ArgumentError, signature.inspect # FIXME
      end
      plaintext = case plaintext
        when Integer      then plaintext
        when String       then PKCS1.os2ip(plaintext)
        when StringIO, IO then PKCS1.os2ip(plaintext.read)
        else raise ArgumentError, plaintext.inspect # FIXME
      end
      verify_integer(signature, plaintext, options)
    end

  protected

    ##
    # @private
    def encrypt_integer(plaintext, options = {})
      PKCS1.rsaep(public_key, plaintext)
    end

    ##
    # @private
    def decrypt_integer(ciphertext, options = {})
      PKCS1.rsadp(private_key, ciphertext)
    end

    ##
    # @private
    def sign_integer(plaintext, options = {})
      PKCS1.rsasp1(private_key, plaintext)
    end

    ##
    # @private
    def verify_integer(signature, plaintext, options = {})
      PKCS1.rsavp1(public_key, signature).eql?(plaintext)
    end
  end # class KeyPair
end # module RSA
