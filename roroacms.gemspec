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
  spec.description   = %q{A full Ruby On Rails CMS engine that is built soley for the purpose of extensibility}
  spec.license       = "MIT"
  spec.post_install_message = "Thanks for installing RoroaCMS!"

  spec.files = `git ls-files`.split($/).reject { |fn| fn.start_with? "spec" }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 4.1.4"
  spec.add_dependency "kaminari", ">= 0"
  spec.add_dependency "ancestry", ">= 0"
  spec.add_dependency "devise", ">= 0"
  spec.add_dependency "diffy", ">= 0"
  spec.add_dependency "coffee-rails", "~> 4.0.0"
  spec.add_dependency "sass-rails", "~> 4.0.3"
  spec.add_dependency "jquery-rails", ">= 0"
  spec.add_dependency "aws-sdk", ">= 0"
  spec.add_dependency "i18n", ">= 0.6.11"
  spec.add_dependency "redcarpet", ">= 0"
  spec.add_dependency "twitter-bootstrap-rails", ">= 0"
  spec.add_dependency "pg", ">= 0"

  spec.add_development_dependency "capybara"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "faker"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "launchy"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "rspec-rails"
end