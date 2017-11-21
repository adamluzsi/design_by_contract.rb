# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "design_by_contract"
  spec.version       = File.read(File.join(__dir__, "VERSION")).strip
  spec.authors       = ["Adam Luzsi"]
  spec.email         = ["adamluzsi@gmail.com"]

  spec.summary       = %q{Design by contract patterns for developer happiness}
  spec.description   = %q{Design by contract patterns for developer happiness}
  spec.homepage      = "https://github.com/adamluzsi/design_by_contract.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
