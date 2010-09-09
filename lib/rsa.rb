require 'bigdecimal' unless defined?(BigDecimal)
require 'stringio'   unless defined?(StringIO)

if RUBY_VERSION < '1.9.1'
  # @see http://rubygems.org/gems/backports
  begin
    require 'backports/1.9.1'
  rescue LoadError
    abort "RSA.rb requires Ruby 1.9.1 or the Backports gem (hint: `gem install backports')."
  end
end

module RSA
  autoload :Math,    'rsa/math'
  autoload :PKCS1,   'rsa/pkcs1'
  autoload :Key,     'rsa/key'
  autoload :KeyPair, 'rsa/key_pair'
  autoload :OpenSSL, 'rsa/openssl'
  autoload :VERSION, 'rsa/version'
end

begin
  require 'openssl'
  require 'rsa/openssl'
rescue LoadError
  # OpenSSL acceleration disabled.
end
