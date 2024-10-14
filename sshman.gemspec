# sshman.gemspec
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sshman/version"

Gem::Specification.new do |spec|
  spec.name          = "sshman"
  spec.version       = SSHMan::VERSION
  spec.authors       = ["Subnetmasked"]
  spec.email         = ["subnetmasked@cock.li"]

  spec.summary       = %q{A fancy SSH connection manager with TUI}
  spec.description   = %q{SSHMan is a command-line tool for managing SSH connections with a user-friendly interface and a Text-based User Interface (TUI).}
  spec.homepage      = "https://github.com/subnetmasked/sshman"
  spec.license       = "GPL-3.0-OR-LATER"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.2"
  spec.add_dependency "tty-table", "~> 0.12"
  spec.add_dependency "tty-prompt", "~> 0.23"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
