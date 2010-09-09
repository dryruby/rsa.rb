require File.join(File.dirname(__FILE__), 'spec_helper')

describe RSA::Math do
  context "RSA::Math.factorize(n)" do
    it "returns an enumerator" do
      RSA::Math.factorize(12).should be_an(Enumerator)
    end
  end

  context "RSA::Math.factorize(0)" do
    it "raises a zero-division error" do
      lambda { RSA::Math.factorize(0) }.should raise_error(ZeroDivisionError)
    end
  end

  context "RSA::Math.factorize(12)" do
    it "returns the prime factors of 12" do
      RSA::Math.factorize(12).to_a.should == [[2, 2], [3, 1]]
    end
  end

  context "RSA::Math.prime?(n) for n = 1..100" do
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

    it "returns false for composites" do
      1.upto(100) do |n|
        RSA::Math.prime?(n).should == false unless primes.include?(n)
      end
    end

    it "returns true for primes" do
      primes.each do |n|
        RSA::Math.prime?(n).should == true
      end
    end
  end

  context "RSA::Math.coprime?(a, b)" do
    it "returns false if not a \u22A5 b" do
      RSA::Math.coprime?(6, 27).should == false
    end

    it "returns true if a \u22A5 b" do
      RSA::Math.coprime?(6, 35).should == true
    end
  end

  context "RSA::Math.gcd(0, 0)" do
    it "returns zero" do
      RSA::Math.gcd(0, 0).should == 0
    end
  end

  context "RSA::Math.gcd(a, 0)" do
    it "returns a" do
      RSA::Math.gcd(3, 0).should == 3
    end
  end

  context "RSA::Math.gcd(a, b)" do
    it "returns an integer" do
      RSA::Math.gcd(3, 5).should be_an(Integer)
    end

    it "returns GCD(a, b)" do
      RSA::Math.gcd(3, 5).should    == 1
      RSA::Math.gcd(8, 12).should   == 4
      RSA::Math.gcd(12, 60).should  == 12
      RSA::Math.gcd(12, 90).should  == 6
      RSA::Math.gcd(42, 56).should  == 14
      RSA::Math.gcd(9, 28).should   == 1
      RSA::Math.gcd(72, 168).should == 24
      RSA::Math.gcd(19, 36).should  == 1
    end
  end

  context "RSA::Math.gcd(a, b) for a = -100..100, b = -100..100" do
    it "returns GCD(a, b)" do
      (-100..100).each do |a|
        (-100..100).each do |b|
          RSA::Math.gcd(a, b).should == a.gcd(b)
          RSA::Math.gcd(b, a).should == b.gcd(a)
        end
      end
    end
  end

  context "RSA::Math.egcd(0, 0)" do
    it "raises a zero-division error" do
      lambda { RSA::Math.egcd(0, 0) }.should raise_error(ZeroDivisionError)
    end
  end

  context "RSA::Math.egcd(a, b)" do
    it "returns a two-element array" do
      RSA::Math.egcd(120, 23).should be_an(Array)
      RSA::Math.egcd(120, 23).should have(2).elements
    end

    it "returns EGCD(a, b)" do
      RSA::Math.egcd(120, 23).should    == [-9, 47]
      RSA::Math.egcd(421, 111).should   == [-29, 110]
      RSA::Math.egcd(93, 219).should    == [33, -14]
      RSA::Math.egcd(4864, 3458).should == [32, -45]
    end
  end

  context "RSA::Math.modinv(a, m)" do
    it "raises an arithmetic error if m <= 0" do
      lambda { RSA::Math.modinv(6, -1) }.should raise_error(RSA::Math::ArithmeticError)
      lambda { RSA::Math.modinv(6, 0) }.should raise_error(RSA::Math::ArithmeticError)
    end

    it "raises an arithmetic error if not a \u22A5 m" do
      lambda { RSA::Math.modinv(6, 36) }.should raise_error(RSA::Math::ArithmeticError)
    end

    it "returns (a\u207B\u00B9 mod m) if a \u22A5 m" do
      RSA::Math.modinv(1, 5).should    == 1
      RSA::Math.modinv(2, 5).should     == 3
      RSA::Math.modinv(3, 5).should     == 2
      RSA::Math.modinv(4, 5).should     == 4
      RSA::Math.modinv(3, 11).should    == 4
      RSA::Math.modinv(6, 35).should    == 6
      RSA::Math.modinv(271, 383).should == 106 # HAC, p. 610
      RSA::Math.modinv(111, 421).should == 110
    end
  end

  if RUBY_PLATFORM =~ /java/ # JRuby only
    # @see http://download.oracle.com/javase/6/docs/api/java/math/BigInteger.html#modInverse(java.math.BigInteger)

    context "RSA::Math.modinv(a, m) for a = -100..100, m = 1..100 where a \u22A5 m" do
      it "returns (a\u207B\u00B9 mod m) if a \u22A5 m" do
        (-100..100).each do |a|
          (1..100).each do |m|
            if RSA::Math.coprime?(a, m) # only test valid arguments
              {[a, m] => RSA::Math.modinv(a, m)}.should == {[a, m] => Java::JavaMath::BigInteger.new(a.to_s).modInverse(m)}
            end
          end
        end
      end
    end
  end

  context "RSA::Math.modpow(1, 1, 0)" do
    it "raises a zero-division error" do
      lambda { RSA::Math.modpow(1, 1, 0) }.should raise_error(ZeroDivisionError)
    end
  end

  context "RSA::Math.modpow(5, 0, 10)" do
    it "returns 1" do
      RSA::Math.modpow(5, 0, 10).should == 1
    end
  end

  context "RSA::Math.modpow(5, 3, 13)" do
    it "returns 8" do
      RSA::Math.modpow(5, 3, 13).should == 8
    end
  end

  context "RSA::Math.modpow(4, 13, 497)" do
    it "returns 445" do
      RSA::Math.modpow(4, 13, 497).should == 445
    end
  end

  context "RSA::Math.modpow(b, e, m) for b = 0..10, e = 1..10, m = 1..10" do
    it "returns the correct result" do
      (0..10).each do |b|
        (1..10).each do |e|
          (1..10).each do |m|
            {[b, e, m] => RSA::Math.modpow(b, e, m)}.should == {[b, e, m] => (b ** e) % m}
          end
        end
      end
    end
  end

  context "RSA::Math.phi(0)" do
    it "returns 1" do
      RSA::Math.phi(0).should == 1 # @see http://mathworld.wolfram.com/TotientFunction.html
    end
  end

  context "RSA::Math.phi(1)" do
    it "returns 1" do
      RSA::Math.phi(1).should == 1 # 1 is coprime to itself
    end
  end

  context "RSA::Math.phi(2)" do
    it "returns 1" do
      RSA::Math.phi(2).should == 1
    end
  end

  context "RSA::Math.phi(n) for n > 2" do
    it "returns an even integer" do
      # @see http://en.wikipedia.org/wiki/Euler's_totient_function#Properties
      3.upto(10_000) do |n|
        RSA::Math.phi(n).should be_even
      end
    end
  end

  context "RSA::Math.phi(n) when n is prime" do
    it "returns n - 1" do
      2.upto(10_000) do |n|
        RSA::Math.phi(n).should == n - 1 if RSA::Math.prime?(n)
      end
    end
  end

  context "RSA::Math.phi(n) for n = 1..69" do
    it "returns \u03D5(n)" do
      # @see http://oeis.org/classic/A000010
      phis = [1, 1, 2, 2, 4, 2, 6, 4, 6, 4, 10, 4, 12, 6, 8, 8, 16, 6, 18, 8, 12, 10, 22, 8, 20, 12, 18, 12, 28, 8, 30, 16, 20, 16, 24, 12, 36, 18, 24, 16, 40, 12, 42, 20, 24, 22, 46, 16, 42, 20, 32, 24, 52, 18, 40, 24, 36, 28, 58, 16, 60, 30, 36, 32, 48, 20, 66, 32, 44]
      phis.each_with_index do |phi, i|
        RSA::Math.phi(n = i + 1).should == phi
      end
    end
  end

  context "RSA::Math.phi(10^e) for e = 1..1000" do
    it "returns \u03D5(n)" do
      1.upto(1_000) do |e|
        RSA::Math.phi(n = 10**e).should == ('4' + '0' * (e - 1)).to_i # RSA::Math.phi(n) == 0.4 * n
      end
    end
  end
end
