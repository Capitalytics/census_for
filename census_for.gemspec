# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "census_for"
  spec.version       = '0.1.5'
  spec.authors       = ["Evan Koch"]
  spec.email         = ["evankoch@gmail.com"]

  spec.summary       = %q{Quickly retrieve US census data for counties/states.}
  spec.description   = %q{Gem returns population data for US States, Counties, including Puerto Rico, US territories.}
  spec.homepage      = "https://github.com/evo21/census_for"
  spec.license       = "MIT"

  spec.files         = ["lib/census_for.rb",
                         "data/2014-census-data.csv"
                       ]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "smarter_csv", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0"
end
