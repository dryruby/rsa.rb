require File.join(File.dirname(__FILE__), 'spec_helper')

describe RSA::Math do
  context "RSA::Math.prime?(n) for n = 1..100" do
    primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

    it "returns true for primes" do
      primes.each do |n|
        RSA::Math.prime?(n).should == true
      end
    end

    it "returns false for composites" do
      1.upto(100) do |n|
        RSA::Math.prime?(n).should == false unless primes.include?(n)
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
      RSA::Math.phi(1).should == 1
    end
  end

  context "RSA::Math.phi(n) for n = 2..10" do
    it "returns \u03D5(n)" do
      [1, 1, 1, 2, 2, 4, 2, 6, 4, 6, 4, 10].each_with_index do |phi, n|
        RSA::Math.phi(n).should == phi
      end
    end
  end
end
