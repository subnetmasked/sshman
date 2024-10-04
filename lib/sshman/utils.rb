require 'csv'
require_relative 'constants'

module Sshman
  class Utils
    def self.ensure_csv_file
      unless File.exist?(SERVERS_CSV)
        File.open(SERVERS_CSV, 'w') { |file| file.puts "alias,hostname,port,username,ssh_key" }
        puts "#{GREEN}Created servers file at #{SERVERS_CSV}.#{RESET_COLOR}"
      end
      File.chmod(0600, SERVERS_CSV)
    end

    def self.display_help
      puts <<-HELP
Usage: sshman [COMMAND]
Commands:
  list          List all saved servers
  add           Add a new server configuration
  edit          Edit an existing server
  delete        Delete a server by its alias
  connect       Connect to a server by its alias
  version       Display the current version
  help          Display this help information
HELP
    end
  end
end
