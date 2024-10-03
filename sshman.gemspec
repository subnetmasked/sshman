Gem::Specification.new do |spec|
  spec.name          = "sshman"
  spec.version       = "0.1.0"
  spec.authors       = ["Victor Bjørke"]
  spec.email         = ["bjorke@startmail.com "]

  spec.summary       = "A terminal-based SSH manager"
  spec.description   = "A simple terminal-based SSH manager to add, list, delete, and connect to SSH servers."
  spec.homepage      = "https://github.com/VictorBjorke/sshman"
  spec.license       = "GPL"

  spec.files         = Dir["lib/**/*", "exe/*"]  # Includes all necessary files
  spec.bindir        = "exe"                     # Executable directory
  spec.executables   = ["sshman"]                # Command to run
  spec.require_paths = ["lib"]                   # Load path for libraries
end
