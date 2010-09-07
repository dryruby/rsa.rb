module RSA
  ##
  # Mathematical helper functions for RSA.
  module Math
    extend ::Math

    class ArithmeticError < ArgumentError; end

    ##
    # Performs a primality test on the integer `n`, returning `true` if it
    # is a prime.
    #
    # @example
    #   1.upto(10).select { |n| RSA::Math.prime?(n) }  #=> [2, 3, 5, 7]
    #
    # @param  [Integer] n
    # @return [Boolean]
    # @see    http://en.wikipedia.org/wiki/Primality_test
    # @see    http://ruby-doc.org/core-1.9/classes/Prime.html
    def self.prime?(n)
      if n.respond_to?(:prime?)
        n.prime?
      else
        require 'prime' unless defined?(Prime) # Ruby 1.9+ only
        Prime.prime?(n)
      end
    end

    ##
    # Returns `true` if the integer `a` is coprime (relatively prime) to
    # integer `b`.
    #
    # @example
    #   RSA::Math.coprime?(6, 35)                      #=> true
    #   RSA::Math.coprime?(6, 27)                      #=> false
    #
    # @param  [Integer] a
    # @param  [Integer] b
    # @return [Boolean]
    # @see    http://en.wikipedia.org/wiki/Coprime
    def self.coprime?(a, b)
      a.gcd(b).equal?(1)
    end

    ##
    # Returns the modular multiplicative inverse of the integer `b` modulo
    # `m`.
    #
    # This is presently a very naive implementation. Don't rely on it for
    # anything but very small values of `m`.
    #
    # @example
    #   RSA::Math.modinv(3, 11)                        #=> 4
    #   RSA::Math.modinv(6, 35)                        #=> 6
    #   RSA::Math.modinv(-6, 35)                       #=> 29
    #   RSA::Math.modinv(6, 36)                        #=> ArithmeticError
    #
    # @param  [Integer] b
    # @param  [Integer] m the modulus
    # @return [Integer]
    # @raise  [ArithmeticError] if `m` <= 0, or if `b` not coprime to `m`
    # @see    http://en.wikipedia.org/wiki/Modular_multiplicative_inverse
    # @see    http://mathworld.wolfram.com/ModularInverse.html
    def self.modinv(b, m)
      if m > 0 && coprime?(b, m)
        (1...m).find { |x| (b * x).modulo(m).equal?(1) } || 0
      else
        raise ArithmeticError, "modulus #{m} is not positive" if m <= 0
        raise ArithmeticError, "#{b} is not coprime to #{m}"
      end
    end

    ##
    # Performs modular exponentiation in a memory-efficient manner.
    #
    # This is equivalent to `base**exponent % modulus` but much faster for
    # large exponents.
    #
    # The running time of the used algorithm, the right-to-left binary
    # method, is O(log _exponent_).
    #
    # @example
    #   RSA::Math.modpow(5, 3, 13)                     #=> 8
    #   RSA::Math.modpow(4, 13, 497)                   #=> 445
    #
    # @param  [Integer] base
    # @param  [Integer] exponent
    # @param  [Integer] modulus
    # @return [Integer]
    # @see    http://en.wikipedia.org/wiki/Modular_exponentiation
    def self.modpow(base, exponent, modulus)
      result = 1
      while exponent > 0
        result   = (base * result) % modulus unless (exponent & 1).zero?
        base     = (base * base)   % modulus
        exponent >>= 1
      end
      result
    end

    ##
    # Returns the Euler totient for the positive integer `n`.
    #
    # This is presently a very naive implementation. Don't rely on it for
    # anything but very small values of `n`.
    #
    # @example
    #   (1..5).map { |n| RSA::Math.phi(n) }            #=> [1, 1, 2, 2, 4]
    #
    # @param  [Integer] n
    # @return [Integer]
    # @see    http://en.wikipedia.org/wiki/Euler's_totient_function
    # @see    http://mathworld.wolfram.com/TotientFunction.html
    def self.phi(n)
      1 + (2...n).count { |i| coprime?(n, i) }
    end

    ##
    # Returns the binary logarithm of `n`.
    #
    # @param  [Integer] n
    # @return [Float]
    # @see    http://en.wikipedia.org/wiki/Binary_logarithm
    def self.log2(n)
      ::Math.log2(n)
    end

    ##
    # Returns the base-256 logarithm of `n`.
    #
    # @param  [Integer] n
    # @return [Float]
    # @see    http://en.wikipedia.org/wiki/Logarithm
    def self.log256(n)
      ::Math.log(n, 256)
    end

    ##
    # Returns the natural logarithm of `n`. If the optional argument `b` is
    # given, it will be used as the base of the logarithm.
    #
    # @param  [Integer] n
    # @param  [Integer] b
    # @return [Float]
    # @see    http://en.wikipedia.org/wiki/Natural_logarithm
    def self.log(n, b = nil)
      b ? ::Math.log(n, b) : ::Math.log(n)
    end
  end
end
