module RSA
  ##
  # Mathematical helper functions for RSA.
  module Math
    extend ::Math

    ##
    # Performs modular exponentiation in a memory-efficient manner.
    #
    # This is equivalent to `base**exponent % modulus` but much faster for
    # large exponents.
    #
    # This is presently a semi-naive implementation. Don't rely on it for
    # very large exponents.
    #
    # @example
    #   RSA::Math.modpow(5, 3, 13)           #=> 8
    #   RSA::Math.modpow(4, 13, 497)         #=> 445
    #
    # @param  [Integer] base
    # @param  [Integer] exponent
    # @param  [Integer] modulus
    # @return [Integer]
    # @see    http://en.wikipedia.org/wiki/Modular_exponentiation
    def self.modpow(base, exponent, modulus)
      1.upto(exponent).inject(1) do |c, e|
        (c * base) % modulus
      end
    end

    ##
    # Returns the Euler totient for the positive integer `n`.
    #
    # This is presently a very naive implementation. Don't rely on it for
    # anything but very small values of `n`.
    #
    # @example
    #   (1..5).map { |n| RSA::Math.phi(n) }  #=> [1, 1, 2, 2, 4]
    #
    # @param  [Integer] n
    # @return [Integer]
    # @see    http://en.wikipedia.org/wiki/Euler's_totient_function
    # @see    http://mathworld.wolfram.com/TotientFunction.html
    def self.phi(n)
      1 + (2...n).count { |i| i.gcd(n).eql?(1) }
    end
  end
end
