require File.join(File.dirname(__FILE__), 'spec_helper')

describe RSA::KeyPair do
  before :all do
    @public_key  = RSA::Key.new(@n = 3233, @e = 17)
    @private_key = RSA::Key.new(@n, @d = 2753)
    @key_pair    = RSA::KeyPair.new(@private_key, @public_key)
  end

  context "#private_key" do
    it "returns a key" do
      @key_pair.private_key.should be_a(RSA::Key)
    end

    it "returns the private key" do
      @key_pair.private_key.should equal(@private_key)
    end
  end

  context "#public_key" do
    it "returns a key" do
      @key_pair.public_key.should be_a(RSA::Key)
    end

    it "returns the public key" do
      @key_pair.public_key.should equal(@public_key)
    end
  end

  context "#valid?" do
    # TODO
  end
end
