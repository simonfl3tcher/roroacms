# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roroacms/version'

Gem::Specification.new do |spec|
  spec.name          = "roroacms"
  spec.version       = Roroacms::VERSION
  spec.authors       = ["Simon Fletcher"]
  spec.email         = ["info@roroacms.co.uk"]
  spec.summary       = %q{A full Ruby On Rails CMS engine providing content management functionality for any Rails 4 application that is fully extendable and is completely boundless}
  spec.homepage      = "http://www.roroacms.co.uk"
  spec.license       = "MIT"
  spec.post_install_message = "Thanks for installing RoroaCMS!"

  spec.files = `git ls-files`.split($/).reject { |fn| fn.start_with? "spec" }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.0.0", "< 5.0"
  spec.add_dependency "bcrypt-ruby", "~> 3.1", ">= 3.1.2"
  spec.add_dependency "ransack", "~> 1.2"
  spec.add_dependency "kaminari", ">= 0.14.1", "< 0.16"
  spec.add_dependency "ancestry"
  spec.add_dependency "devise"
  spec.add_dependency "diffy"
  spec.add_dependency "coffee-rails", "~> 4"
  spec.add_dependency "sass-rails", "~> 4.0"
  spec.add_dependency "uglifier", ">= 2.2", "< 3.0"
  spec.add_dependency "aws-sdk"
  spec.add_dependency "redcarpet"
  spec.add_dependency "twitter-bootstrap-rails"
  spec.add_dependency "pg"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake", "~> 10.0"
end