module RSA
  ##
  # Mathematical helper functions for RSA.
  module Math
    extend ::Math

    class ArithmeticError < ArgumentError; end

    ##
    # Yields an infinite pseudo-prime number sequence.
    #
    # This is a pseudo-prime generator that simply yields the initial values
    # 2 and 3, followed by all positive integers that are not divisible by 2
    # or 3.
    #
    # It works identically to `Prime::Generator23`, the Ruby 1.9 standard
    # library's default pseudo-prime generator implementation.
    #
    # @example
    #   RSA::Math.primes.take(5)                       #=> [2, 3, 5, 7, 11]
    #
    # @yield  [p] each pseudo-prime number
    # @yieldparam [Integer] p a pseudo-prime number
    # @return [Enumerator] yielding pseudo-primes
    # @see    http://ruby-doc.org/core-1.9/classes/Prime.html
    def self.primes(&block)
      if block_given?
        yield 2; yield 3; yield 5
        prime, step = 5, 4
        loop { yield prime += (step = 6 - step) }
      end
      enum_for(:primes)
    end

    ##
    # Yields the prime factorization of the nonzero integer `n`.
    #
    # @example
    #   RSA::Math.factorize(12).to_a                   #=> [[2, 2], [3, 1]]
    #
    # @param  [Integer] n a nonzero integer
    # @yield  [p, e] each prime factor
    # @yieldparam [Integer] p the prime factor base
    # @yieldparam [Integer] e the prime factor exponent
    # @return [Enumerator]
    # @raise  [ZeroDivisionError] if `n` is zero
    # @see    http://ruby-doc.org/core-1.9/classes/Prime.html
    def self.factorize(n, &block)
      raise ZeroDivisionError if n.zero?
      if block_given?
        n = n.abs if n < 0
        primes.find do |p|
          e = 0
          while (q, r = n.divmod(p); r.zero?)
            n, e = q, e + 1
          end
          yield p, e unless e.zero?
          n <= p
        end
        yield n, 1 if n > 1
      end
      enum_for(:factorize, n)
    end

    ##
    # Performs a primality test on the integer `n`, returning `true` if it
    # is a prime.
    #
    # @example
    #   1.upto(10).select { |n| RSA::Math.prime?(n) }  #=> [2, 3, 5, 7]
    #
    # @param  [Integer] n an integer
    # @return [Boolean] `true` if `n` is a prime number, `false` otherwise
    # @see    http://en.wikipedia.org/wiki/Primality_test
    # @see    http://ruby-doc.org/core-1.9/classes/Prime.html
    def self.prime?(n)
      case
        when n < 0 then prime?(n.abs)
        when n < 2 then false
        else primes do |p|
          q, r = n.divmod(p)
          return true  if q < p
          return false if r.zero?
        end
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
    # @param  [Integer] a an integer
    # @param  [Integer] b an integer
    # @return [Boolean] `true` if `a` and `b` are coprime, `false` otherwise
    # @see    http://en.wikipedia.org/wiki/Coprime
    # @see    http://mathworld.wolfram.com/RelativelyPrime.html
    def self.coprime?(a, b)
      egcd = self.egcd(a, b)
      (a*egcd[0] + b*egcd[1]).eql?(1)
    end

    ##
    # Returns the greatest common divisor (GCD) of the two integers `a` and
    # `b`. The GCD is the largest positive integer that divides both numbers
    # without a remainder.
    #
    # @example
    #   RSA::Math.gcd(3, 5)                            #=> 1
    #   RSA::Math.gcd(8, 12)                           #=> 4
    #   RSA::Math.gcd(12, 60)                          #=> 12
    #   RSA::Math.gcd(90, 12)                          #=> 6
    #
    # @param  [Integer] a an integer
    # @param  [Integer] b an integer
    # @return [Integer] the greatest common divisor of `a` and `b`
    # @see    http://en.wikipedia.org/wiki/Greatest_common_divisor
    # @see    http://mathworld.wolfram.com/GreatestCommonDivisor.html
    def self.gcd(a, b)
      a.gcd(b)
    end

    ##
    # Returns the Bezout coefficients of the two nonzero integers `a` and
    # `b` using the extended Euclidean algorithm.
    #
    # @example
    #   RSA::Math.egcd(120, 23)                        #=> [-9, 47]
    #   RSA::Math.egcd(421, 111)                       #=> [-29, 110]
    #   RSA::Math.egcd(93, 219)                        #=> [33, -14]
    #   RSA::Math.egcd(4864, 3458)                     #=> [32, -45]
    #
    # @param  [Integer] a a nonzero integer
    # @param  [Integer] b a nonzero integer
    # @return [Array(Integer, Integer)] the Bezout coefficients `x` and `y`
    # @raise  [ZeroDivisionError] if `a` or `b` is zero
    # @see    http://en.wikipedia.org/wiki/B%C3%A9zout's_identity
    # @see    http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    # @see    http://mathworld.wolfram.com/ExtendedGreatestCommonDivisor.html
    def self.egcd(a, b)
      if a.modulo(b).zero?
        [0, 1]
      else
        x, y = egcd(b, a.modulo(b))
        [y, x - y * a.div(b)]
      end
    end

    ##
    # Returns the modular multiplicative inverse of the integer `b` modulo
    # `m`, where `b <= m`.
    #
    # The running time of the used algorithm, the extended Euclidean
    # algorithm, is on the order of O(log2 _m_).
    #
    # @example
    #   RSA::Math.modinv(3, 11)                        #=> 4
    #   RSA::Math.modinv(6, 35)                        #=> 6
    #   RSA::Math.modinv(-6, 35)                       #=> 29
    #   RSA::Math.modinv(6, 36)                        #=> ArithmeticError
    #
    # @param  [Integer] b
    # @param  [Integer] m the modulus
    # @return [Integer] the modular multiplicative inverse
    # @raise  [ArithmeticError] if `m` <= 0, or if `b` not coprime to `m`
    # @see    http://en.wikipedia.org/wiki/Modular_multiplicative_inverse
    # @see    http://mathworld.wolfram.com/ModularInverse.html
    def self.modinv(b, m)
      if m > 0 && coprime?(b, m)
        egcd(b, m).first.modulo(m)
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
    # method, is on the order of O(log _exponent_).
    #
    # @example
    #   RSA::Math.modpow(5, 3, 13)                     #=> 8
    #   RSA::Math.modpow(4, 13, 497)                   #=> 445
    #
    # @param  [Integer] base the base
    # @param  [Integer] exponent the exponent
    # @param  [Integer] modulus the modulus
    # @return [Integer] the result
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

    ONE = BigDecimal('1')

    ##
    # Returns the Euler totient for the positive integer `n`.
    #
    # @example
    #   (1..5).map { |n| RSA::Math.phi(n) }            #=> [1, 1, 2, 2, 4]
    #
    # @param  [Integer] n a positive integer, or zero
    # @return [Integer] the Euler totient of `n`
    # @raise  [ArgumentError] if `n` < 0
    # @see    http://en.wikipedia.org/wiki/Euler's_totient_function
    # @see    http://mathworld.wolfram.com/TotientFunction.html
    def self.phi(n)
      case
        when n < 0     then raise ArgumentError, "expected a positive integer, but got #{n}"
        when n < 2     then 1 # by convention
        when prime?(n) then n - 1
        else factorize(n).inject(n) { |product, (p, e)| product * (ONE - (ONE / BigDecimal(p.to_s))) }.round.to_i
      end
    end

    ##
    # Returns the binary logarithm of `n`.
    #
    # @example
    #   RSA::Math.log2(16)                             #=> 4.0
    #   RSA::Math.log2(1024)                           #=> 10.0
    #
    # @param  [Integer] n a positive integer
    # @return [Float] the logarithm
    # @raise  [Errno::EDOM] if `n` < 1
    # @see    http://en.wikipedia.org/wiki/Binary_logarithm
    def self.log2(n)
      ::Math.log2(n)
    end

    ##
    # Returns the base-256 logarithm of `n`.
    #
    # @example
    #   RSA::Math.log256(16)                           #=> 0.5
    #   RSA::Math.log256(1024)                         #=> 1.25
    #
    # @param  [Integer] n a positive integer
    # @return [Float] the logarithm
    # @raise  [Errno::EDOM] if `n` < 1
    # @see    http://en.wikipedia.org/wiki/Logarithm
    def self.log256(n)
      ::Math.log(n, 256)
    end

    ##
    # Returns the natural logarithm of `n`. If the optional argument `b` is
    # given, it will be used as the base of the logarithm.
    #
    # @example
    #   RSA::Math.log(16, 2)                           #=> 4.0
    #   RSA::Math.log(16, 256)                         #=> 0.5
    #
    # @param  [Integer] n a positive integer
    # @param  [Integer] b a positive integer >= 2, or `nil`
    # @return [Float] the logarithm
    # @raise  [Errno::EDOM] if `n` < 1, or if `b` < 2
    # @see    http://en.wikipedia.org/wiki/Natural_logarithm
    def self.log(n, b = nil)
      b ? ::Math.log(n, b) : ::Math.log(n)
    end
  end
end
