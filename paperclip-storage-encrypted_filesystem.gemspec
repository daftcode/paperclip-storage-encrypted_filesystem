# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paperclip/storage/encrypted_filesystem/version'

Gem::Specification.new do |spec|
  spec.name          = "paperclip-storage-encrypted_filesystem"
  spec.version       = Paperclip::Storage::EncryptedFilesystem::VERSION
  spec.authors       = ["Maciej Głowacki", "Jan Grodowski", "Patryk Pastewski"]
  spec.email         = ["maciej.glowacki@daftcode.pl", "jan.grodowski@daftcode.pl", "patryk.pastewski@daftcode.pl"]

  spec.summary       = %q{This gem extends Paperclip with support for automatic attachment encryption.}
  spec.homepage      = "http://daftco.de"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "paperclip"
  spec.add_dependency "encryptoid"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activerecord", ">= 3.0.0"
  spec.add_development_dependency "sqlite3"
end
