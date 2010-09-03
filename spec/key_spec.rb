require File.join(File.dirname(__FILE__), 'spec_helper')

describe RSA::Key do
  before :all do
    @public_key  = RSA::Key.new(@n = 3233, @e = 17)
    @private_key = RSA::Key.new(@n, @d = 2753)
  end

  context "#modulus" do
    it "returns an integer" do
      @public_key.modulus.should be_an(Integer)
    end
  end

  context "#exponent" do
    it "returns an integer" do
      @public_key.exponent.should be_an(Integer)
    end
  end

  context "#valid?" do
    # TODO
  end

  context "#to_a" do
    it "returns an array" do
      @public_key.to_a.should be_an(Array)
    end

    it "returns an array with two elements" do
      @public_key.to_a.should have(2).elements
    end
  end
end
