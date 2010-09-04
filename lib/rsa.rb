require 'prime' unless defined?(Prime) # 1.9+ only

module RSA
  autoload :Math,    'rsa/math'
  autoload :PKCS1,   'rsa/pkcs1'
  autoload :Key,     'rsa/key'
  autoload :KeyPair, 'rsa/key_pair'
  autoload :VERSION, 'rsa/version'
end
