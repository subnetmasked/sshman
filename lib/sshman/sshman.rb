# lib/sshman/sshman.rb

require 'csv'
require 'io/console'

module Sshman
  class CLI
    # This method handles inline commands
    def self.start(argv)
      case argv[0]
      when 'list'
        new.list_servers
      when 'add'
        new.add_server
      when 'edit'
        new.edit_server
      when 'delete'
        new.delete_server
      when 'connect'
        new.connect_to_server
      when 'help'
        new.display_help
      when 'version'
        new.version
      else
        puts "Unknown command: #{argv[0]}. Use 'sshman help' for a list of commands."
      end
    end

    # Display the current version
    
    def version
      puts "sshman version 0.2.0"
    end

    # This method starts the interactive menu (default)
    def self.start_interactive
      new.main
    end

    # Main interactive loop
    def main
      ensure_csv_file

      loop do
        puts "\n#{YELLOW}Options:#{RESET_COLOR} list, add, edit, delete, connect, help, quit"
        print "#{CYAN}Choose an option: #{RESET_COLOR}"
        option = gets.chomp.downcase.strip

        case option
        when 'list'
          list_servers
        when 'add'
          add_server
        when 'edit'
          edit_server
        when 'delete'
          delete_server
        when 'connect'
          connect_to_server
        when 'help'
          display_help
        when 'quit'
          puts "#{GREEN}Goodbye!#{RESET_COLOR}"
          break
        else
          puts "#{RED}Unknown option '#{option}'. Type 'help' for usage instructions.#{RESET_COLOR}"
        end
      end
    end

    # Ensure the CSV file exists and is secure
    def ensure_csv_file
      unless File.exist?(SERVERS_CSV)
        File.open(SERVERS_CSV, 'w') { |file| file.puts "alias,hostname,port,username,ssh_key" }
        puts "#{GREEN}Created servers file at #{SERVERS_CSV}.#{RESET_COLOR}"
      end
      File.chmod(0600, SERVERS_CSV) # Restrict file permissions for security
    end

    # Display help information
    def display_help
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

    # List all servers in a formatted table with colors
    def list_servers
      if File.zero?(SERVERS_CSV)
        puts "#{YELLOW}No servers found. Add some using the 'add' option.#{RESET_COLOR}"
        return
      end

      puts "#{CYAN}%-15s %-25s %-6s %-15s %-30s#{RESET_COLOR}" % ["Alias", "Hostname", "Port", "Username", "SSH Key"]
      puts "-" * 95

      CSV.foreach(SERVERS_CSV, headers: true) do |row|
        puts "%-15s %-25s %-6s %-15s %-30s" % [row['alias'], row['hostname'], row['port'], row['username'], row['ssh_key']]
      end
    end
    
    # Add a new server to the CSV file
    def add_server
      puts "#{CYAN}Adding a new server...#{RESET_COLOR}"
      print "Alias: "
      alias_name = gets.chomp.strip
      return puts "#{RED}Alias cannot be empty!#{RESET_COLOR}" if alias_name.empty?

      print "Hostname or IP: "
      hostname = gets.chomp.strip
      return puts "#{RED}Hostname cannot be empty!#{RESET_COLOR}" if hostname.empty?

      print "Port (default 22): "
      port = gets.chomp.strip
      port = '22' if port.empty?

      print "Username: "
      username = gets.chomp.strip
      return puts "#{RED}Username cannot be empty!#{RESET_COLOR}" if username.empty?

      print "Path to SSH key (leave blank if none): "
      ssh_key = gets.chomp.strip

      CSV.open(SERVERS_CSV, 'a+') do |csv|
        csv << [alias_name, hostname, port, username, ssh_key]
      end

      puts "#{GREEN}Server '#{alias_name}' added successfully!#{RESET_COLOR}"
    end

    # Edit an existing server's details
    def edit_server
      print "Enter alias of the server to edit: "
      alias_name = gets.chomp.strip
      servers = CSV.table(SERVERS_CSV)

      server = servers.find { |row| row[:alias] == alias_name }
      unless server
        puts "#{RED}No server found with alias '#{alias_name}'.#{RESET_COLOR}"
        return
      end

      print "New Hostname (leave blank to keep current: #{server[:hostname]}): "
      new_hostname = gets.chomp.strip
      server[:hostname] = new_hostname unless new_hostname.empty?

      print "New Port (leave blank to keep current: #{server[:port]}): "
      new_port = gets.chomp.strip
      server[:port] = new_port unless new_port.empty?

      print "New Username (leave blank to keep current: #{server[:username]}): "
      new_username = gets.chomp.strip
      server[:username] = new_username unless new_username.empty?

      print "New SSH Key Path (leave blank to keep current: #{server[:ssh_key]}): "
      new_ssh_key = gets.chomp.strip
      server[:ssh_key] = new_ssh_key unless new_ssh_key.empty?

      CSV.open(SERVERS_CSV, 'w') do |csv|
        csv << servers.headers
        servers.each { |row| csv << row }
      end

      puts "#{GREEN}Server '#{alias_name}' updated successfully!#{RESET_COLOR}"
    end

    # Delete a server from the CSV file
    def delete_server
      print "Enter alias of the server to delete: "
      alias_name = gets.chomp.strip
      servers = CSV.table(SERVERS_CSV)

      if servers.delete_if { |row| row[:alias] == alias_name }
        CSV.open(SERVERS_CSV, 'w') do |csv|
          csv << servers.headers
          servers.each { |row| csv << row }
        end
        puts "#{GREEN}Server '#{alias_name}' deleted successfully!#{RESET_COLOR}"
      else
        puts "#{RED}No server found with alias '#{alias_name}'.#{RESET_COLOR}"
      end
    end

    # Connect to a server using SSH
    def connect_to_server
      print "Enter alias of the server to connect: "
      alias_name = gets.chomp.strip
      server = nil

      CSV.foreach(SERVERS_CSV, headers: true) do |row|
        if row['alias'] == alias_name
          server = row
          break
        end
      end

      unless server
        puts "#{RED}No server found with alias '#{alias_name}'.#{RESET_COLOR}"
        return
      end

      ssh_command = "ssh #{server['username']}@#{server['hostname']} -p #{server['port']}"
      ssh_command += " -i #{server['ssh_key']}" unless server['ssh_key'].to_s.empty?

      puts "#{CYAN}Connecting to #{alias_name}...#{RESET_COLOR}"
      exec ssh_command
    end

    # Constants for coloring terminal output
    RESET_COLOR = "\033[0m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    CYAN = "\033[36m"
    SERVERS_CSV = File.expand_path("~/.sshman_servers.csv")
  end
end
