Gem::Specification.new do |spec|
  spec.name          = "lita-pco-api-client"
  spec.version       = "0.1.0"
  spec.authors       = ["Gabi Jack"]
  spec.email         = ["gabi@ministrycentered.com"]
  spec.description   = "Authenticate PCO users and use API"
  spec.summary       = "Authenticate PCO users and use API"
  spec.homepage      = "https://github.com/gjack/lita-pco-api-client"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "oauth2"
  spec.add_runtime_dependency "pco_api"
  spec.add_runtime_dependency "launchy"

  spec.add_development_dependency "bundler", "> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
end
