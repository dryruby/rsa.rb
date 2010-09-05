require File.join(File.dirname(__FILE__), 'spec_helper')

describe RSA::PKCS1 do
  context "RSA::PKCS1.i2osp" do
    it "raises an error if x >= 256**len" do
      lambda { RSA::PKCS1.i2osp(256**3, 2) }.should raise_error(ArgumentError)
      lambda { RSA::PKCS1.i2osp(9_202_000, 2) }.should raise_error(ArgumentError)
    end

    it "returns the correct octet string" do
      RSA::PKCS1.i2osp(9_202_000, 3).should == "\x8C\x69\x50"
    end

    it "inserts leading zeroes as needed" do
      RSA::PKCS1.i2osp(9_202_000, 4).should == "\x00\x8C\x69\x50"
      RSA::PKCS1.i2osp(9_202_000, 5).should == "\x00\x00\x8C\x69\x50"
    end

    it "encodes zero correctly" do
      RSA::PKCS1.i2osp(0, 1).should == "\x00"
    end
  end

  context "RSA::PKCS1.os2ip" do
    it "returns the correct integer value" do
      RSA::PKCS1.os2ip("\x00").should == 0
      RSA::PKCS1.os2ip("\x8C\x69\x50").should == 9_202_000
    end

    it "decodes zero correctly" do
      RSA::PKCS1.os2ip("\x00").should == 0
    end
  end
end
