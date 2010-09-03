require File.join(File.dirname(__FILE__), 'spec_helper')

describe RSA::Math do
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
