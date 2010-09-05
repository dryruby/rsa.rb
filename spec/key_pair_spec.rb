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

  context "#private_key?" do
    it "returns true" do
      @key_pair.should be_private_key
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

  context "#public_key?" do
    it "returns true" do
      @key_pair.should be_public_key
    end
  end

  context "#valid?" do
    # TODO
  end

  context "#encrypt" do
    it "accepts an integer argument" do
      lambda { @key_pair.encrypt(42) }.should_not raise_error(ArgumentError)
    end

    it "accepts a string argument" do
      lambda { @key_pair.encrypt(42.chr) }.should_not raise_error(ArgumentError)
    end

    it "accepts an IO argument" do
      lambda { @key_pair.encrypt(StringIO.open { |buffer| buffer << 42.chr }) }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      @key_pair.encrypt(42).should be_a(String)
    end
  end

  context "#decrypt" do
    it "accepts an integer argument" do
      lambda { @key_pair.decrypt(42) }.should_not raise_error(ArgumentError)
    end

    it "accepts a string argument" do
      lambda { @key_pair.decrypt(42.chr) }.should_not raise_error(ArgumentError)
    end

    it "accepts an IO argument" do
      lambda { @key_pair.decrypt(StringIO.open { |buffer| buffer << 42.chr }) }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      @key_pair.decrypt(2557).should be_a(String)
    end
  end

  context "#sign" do
    it "accepts an integer argument" do
      lambda { @key_pair.sign(42) }.should_not raise_error(ArgumentError)
    end

    it "accepts a string argument" do
      lambda { @key_pair.sign(42.chr) }.should_not raise_error(ArgumentError)
    end

    it "accepts an IO argument" do
      lambda { @key_pair.sign(StringIO.open { |buffer| buffer << 42.chr }) }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      @key_pair.sign(42).should be_a(String)
    end
  end
end
