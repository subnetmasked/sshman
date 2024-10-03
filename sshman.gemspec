
# sshman.gemspec
Gem::Specification.new do |spec|
  spec.name          = "sshman"
  spec.version       = "0.1.0"
  spec.authors       = ["Victor Bjørke"]
  spec.email         = ["bjorke@startmail.com"]

  spec.summary       = "A terminal-based SSH manager"
  spec.description   = "A simple terminal-based SSH manager to add, list, delete, and connect to SSH servers."
  spec.homepage      = "https://github.com/VictorBjorke/sshman"
  spec.license       = "GPLv3"

  spec.files         = Dir["lib/**/*"]
  spec.bindir        = "exe"
  spec.executables   = ["sshman"]
  spec.require_paths = ["lib"]

  spec.metadata = {
    "source_code_uri" => "https://github.com/VictorBjorke/sshman",
    "changelog_uri" => "https://github.com/VictorBjorke/sshman",
  }

  # Specify required Ruby version
  spec.required_ruby_version = ">= 2.3.0"
end
