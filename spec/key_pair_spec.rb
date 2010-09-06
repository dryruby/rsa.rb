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

  context "#bytesize" do
    it "returns an integer" do
      @key_pair.bytesize.should be_an(Integer)
    end
  end

  context "#bitsize" do
    it "returns an integer" do
      @key_pair.bitsize.should be_an(Integer)
    end
  end

  context "#modulus" do
    it "returns an integer" do
      @key_pair.modulus.should be_an(Integer)
    end
  end

  context "#encrypt(Integer)" do
    it "accepts an integer argument" do
      lambda { @key_pair.encrypt(42) }.should_not raise_error(ArgumentError)
    end

    it "returns an integer" do
      @key_pair.encrypt(42).should be_an(Integer)
    end
  end

  context "#encrypt(String)" do
    it "accepts a string argument" do
      lambda { @key_pair.encrypt(42.chr) }.should_not raise_error(ArgumentError)
    end

    it "accepts an IO argument" do
      lambda { @key_pair.encrypt(StringIO.open { |buffer| buffer << 42.chr }) }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      @key_pair.encrypt(42.chr).should be_a(String)
    end
  end

  context "#decrypt(Integer)" do
    it "accepts an integer argument" do
      lambda { @key_pair.decrypt(42) }.should_not raise_error(ArgumentError)
    end

    it "returns an integer" do
      @key_pair.decrypt(2557).should be_an(Integer)
    end
  end

  context "#decrypt(String)" do
    it "accepts a string argument" do
      lambda { @key_pair.decrypt(42.chr) }.should_not raise_error(ArgumentError)
    end

    it "accepts an IO argument" do
      lambda { @key_pair.decrypt(StringIO.open { |buffer| buffer << 42.chr }) }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      @key_pair.decrypt(RSA::PKCS1.i2osp(2557)).should be_a(String)
    end
  end

  context "#sign(Integer)" do
    it "accepts an integer argument" do
      lambda { @key_pair.sign(42) }.should_not raise_error(ArgumentError)
    end

    it "returns an integer" do
      @key_pair.sign(42).should be_an(Integer)
    end
  end

  context "#sign(String)" do
    it "accepts a string argument" do
      lambda { @key_pair.sign(42.chr) }.should_not raise_error(ArgumentError)
    end

    it "accepts an IO argument" do
      lambda { @key_pair.sign(StringIO.open { |buffer| buffer << 42.chr }) }.should_not raise_error(ArgumentError)
    end

    it "returns a string" do
      @key_pair.sign(42.chr).should be_a(String)
    end
  end

  context "#verify(Integer)" do
    it "accepts integer arguments" do
      lambda { @key_pair.verify(3065, 42) }.should_not raise_error(ArgumentError)
    end

    it "returns a boolean" do
      @key_pair.verify(3065, 42).should be_true
    end
  end

  context "#verify(String)" do
    it "accepts string arguments" do
      lambda { @key_pair.verify(RSA::PKCS1.i2osp(3065), 42.chr) }.should_not raise_error(ArgumentError)
    end

    it "accepts IO arguments" do
      lambda { @key_pair.verify(StringIO.open { |buffer| buffer << RSA::PKCS1.i2osp(3065) }, StringIO.open { |buffer| buffer << 42.chr }) }.should_not raise_error(ArgumentError)
    end

    it "returns a boolean" do
      @key_pair.verify(RSA::PKCS1.i2osp(3065), 42.chr).should be_true
    end
  end
end
