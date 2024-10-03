require_relative "lib/sshman/version"

Gem::Specification.new do |spec|
  spec.name          = "sshman"
  spec.version       = Sshman::VERSION
  spec.authors       = ["SubnetMasked"]
  spec.email         = ["bjorke@startmail.com "]

  spec.summary       = "A terminal-based SSH manager"
  spec.description   = "A simple terminal-based SSH manager to add, list, delete, and connect to SSH servers."
  spec.homepage      = "https://github.com/subnetmasked/sshman"
  spec.license       = "GPL-3.0"

  spec.files         = Dir["lib/**/*", "exe/*"]  # Includes all necessary files
  spec.bindir        = "exe"                     # Executable directory
  spec.executables   = ["sshman"]                # Command to run
  spec.require_paths = ["lib"]                   # Load path for libraries
end
