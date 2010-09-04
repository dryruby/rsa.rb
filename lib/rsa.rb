require 'prime' unless defined?(Prime) # 1.9+ only

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
