# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_commit_autouser/version'

Gem::Specification.new do |spec|
  spec.name          = "git-commit-autouser"
  spec.version       = GitCommitAutouser::VERSION
  spec.authors       = ["Ryota Arai"]
  spec.email         = ["ryota.arai@gmail.com"]
  spec.description   = %q{git-commit with auto user select}
  spec.summary       = %q{git-commit with auto user select}
  spec.homepage      = "https://github.com/ryotarai/git-commit-autouser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-debugger"
end
