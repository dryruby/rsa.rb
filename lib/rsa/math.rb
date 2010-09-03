module RSA
  ##
  # Mathematical helper functions for RSA.
  module Math
    extend ::Math

    ##
    # Returns the Euler totient for the positive integer `n`.
    #
    # This is presently a naive implementation for explanatory purposes.
    # Don't rely on it for anything but very small values of `n`.
    #
    # @example
    #   RSA::Math.phi(1)  #=> 1
    #   RSA::Math.phi(2)  #=> 1
    #   RSA::Math.phi(3)  #=> 2
    #   RSA::Math.phi(4)  #=> 2
    #   RSA::Math.phi(5)  #=> 4
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
