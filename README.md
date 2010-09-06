RSA.rb: RSA Encryption for Ruby
===============================

RSA.rb is a [Ruby][] library that implements the [RSA][] encryption
algorithm and the [PKCS#1][] cryptography standard.

* <http://github.com/bendiken/rsa>

Features
--------

* 100% free and unencumbered [public domain](http://unlicense.org/) software.
* Implements the PKCS#1 data conversion primitives (I2OSP and OS2IP).
* Implements the PKCS#1 encryption/decryption primitives (RSAEP and RSADP).
* Implements the PKCS#1 signature primitives (RSASP1 and RSAVP1).
* Implements RSA key pair generation using Ruby's OpenSSL standard library.
* Compatible with Ruby 1.9.1+ and JRuby 1.5.0+.
* Compatible with older Ruby versions with the help of the [Backports][] gem.

Examples
--------

    require 'rsa'

### Generating a new RSA key pair

    key_pair = RSA::KeyPair.generate(128)

### Encrypting a plaintext message

    ciphertext = key_pair.encrypt("Hello, world!")

### Decrypting a ciphertext message

    plaintext = key_pair.decrypt(ciphertext)

Documentation
-------------

<http://rsa.rubyforge.org/>

* {RSA::KeyPair}
* {RSA::Key}
* {RSA::PKCS1}

Dependencies
------------

* [Ruby](http://ruby-lang.org/) (>= 1.9.1) or (>= 1.8.1 with [Backports][])

Installation
------------

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of RSA.rb, do:

    % [sudo] gem install rsa             # Ruby 1.9.1+
    % [sudo] gem install backports rsa   # Ruby 1.8.x

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rsa.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/rsa/tarball/master

Author
------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>

Contributors
------------

Refer to the accompanying {file:CREDITS} file.

Contributing
------------

* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
* Do document every method you add using [YARD][] annotations. Read the
  [tutorial][YARD-GS] or just look at the existing code for examples.
* Don't touch the `.gemspec`, `VERSION` or `AUTHORS` files. If you need to
  change them, do so on your private branch only.
* Do feel free to add yourself to the `CREDITS` file and the corresponding
  list in the the `README`. Alphabetical order applies.
* Do note that in order for us to merge any non-trivial changes (as a rule
  of thumb, additions larger than about 15 lines of code), we need an
  explicit [public domain dedication][PDD] on record from you.

License
-------

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[Ruby]:      http://ruby-lang.org/
[RSA]:       http://en.wikipedia.org/wiki/RSA
[PKCS#1]:    http://en.wikipedia.org/wiki/PKCS1
[YARD]:      http://yardoc.org/
[YARD-GS]:   http://rubydoc.info/docs/yard/file/docs/GettingStarted.md
[PDD]:       http://unlicense.org/#unlicensing-contributions
[Backports]: http://rubygems.org/gems/backports
