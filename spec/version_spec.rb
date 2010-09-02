require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'RSA::VERSION' do
  it "matches the VERSION file" do
    RSA::VERSION.to_s.should == File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp
  end
end
