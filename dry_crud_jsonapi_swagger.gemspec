$:.push File.expand_path("../lib", __FILE__)
require "dry_crud_jsonapi_swagger/version"

Gem::Specification.new do |spec|
  spec.name        = "dry_crud_jsonapi_swagger"
  spec.version     = DryCrudJsonapiSwagger::VERSION
  spec.authors     = ["Daniel Illi"]
  spec.email       = ["illi@puzzle.ch"]

  spec.homepage    = "https://rubygems.org/gems/dry_crud_jsonapi_swagger"
  spec.summary     = "Automatic swagger documentation for dry_crud_jsonapi"
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  # spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "dry_crud_jsonapi", "~> 0.1.0"
  spec.add_runtime_dependency "rswag-ui", "~> 2.0.5"
  spec.add_runtime_dependency "swagger-blocks", "~> 2.0.2"
end
