$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "work_crew/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "work_crew"
  s.version     = WorkCrew::VERSION
  s.authors     = ["Kevin Burleigh, JP Slavinsky"]
  s.email       = ["kb35@rice.edu, jps@kindlinglabs.com"]
  s.homepage    = "https://github.com/openstax/work_crew"
  s.summary     = "Self-managing and -distributing workers"
  s.description = "Self-managing and -distributing workers"
  s.test_files  = Dir["spec/**/*"]
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"

  s.add_development_dependency "rspec-rails", "~> 3.7"
  s.add_development_dependency "pg"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "byebug"
  s.add_development_dependency "chronic"
end
