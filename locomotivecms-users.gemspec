$:.push File.expand_path("../lib", __FILE__)

require 'locomotive/users/version'

Gem::Specification.new do |s|
  s.name = 'locomotivecms-users'
  s.version = Locomotive::Users::VERSION
  s.authors = ['Ryan Aipperspach']
  s.email = ['ryan.aipperspach@gmail.com']
  s.license = 'MIT'
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "locomotive_cms", ">= 2.3"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara-webkit"
  s.add_development_dependency "factory_girl"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "launchy"
  s.add_development_dependency "parallel_tests"
  s.add_development_dependency "capybara-screenshot"
end
