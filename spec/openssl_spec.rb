require File.join(File.dirname(__FILE__), 'spec_helper')

describe RSA::OpenSSL do
  before :all do
    @public_key  = RSA::Key.new(@n = 3233, @e = 17)
    @private_key = RSA::Key.new(@n, @d = 2753)
    @key_pair    = RSA::KeyPair.new(@private_key, @public_key)
  end

  context "RSA::KeyPair#to_openssl" do
    it "should return an OpenSSL::PKey::RSA instance" do
      @key_pair.to_openssl.should be_a(OpenSSL::PKey::RSA)
    end
  end
end
