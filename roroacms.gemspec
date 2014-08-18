$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "roroacms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "roroacms"
  s.version     = "0.0.2"
  s.authors     = ["Simon Fletcher"]
  s.email       = ["simonfletcher0@gmail.com"]
  s.homepage    = "http://roroacms.co.uk"
  s.summary     = "Not Just another rails CMS platform."
  s.licenses    = ['MIT']
  s.description = "A full Rails engine providing content management functionality for any Rails 4 application that is fully extendable and is completely boundless"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.4"
  s.add_dependency "jquery-rails"
  s.add_dependency "kaminari"
  s.add_dependency "ancestry"
  s.add_dependency "devise"
  s.add_dependency "diffy"
  s.add_dependency "twitter-bootstrap-rails"
  s.add_dependency "aws-sdk"
  s.add_dependency "redcarpet"
  s.add_dependency "pg"

  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "faker"
  s.add_development_dependency "capybara"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "launchy"

end
