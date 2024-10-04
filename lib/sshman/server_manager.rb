require 'csv'
require_relative 'constants'

module Sshman
  class ServerManager
    def self.list_servers
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

    def self.add_server
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

    def self.edit_server
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

    def self.delete_server
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

    def self.connect_to_server(alias_name = nil)
      if alias_name.nil?
        print "Enter alias of the server to connect: "
        alias_name = gets.chomp.strip
      end

      server = nil
      CSV.foreach(SERVERS_CSV, headers: true) do |row|
        if row['alias'] == alias_name
          server = row
          break
        end
      end

      unless server
        CLI::LOGGER.error("Failed connection attempt to #{alias_name}: No server found")
        puts "#{RED}No server found with alias '#{alias_name}'.#{RESET_COLOR}"
        return
      end

      ssh_command = "ssh #{server['username']}@#{server['hostname']} -p #{server['port']}"
      ssh_command += " -i #{server['ssh_key']}" unless server['ssh_key'].to_s.empty?

      CLI::LOGGER.info("Connecting to #{alias_name}...")

      if system(ssh_command)
        CLI::LOGGER.info("Successfully connected to #{alias_name}")
      else
        CLI::LOGGER.error("Failed to connect to #{alias_name}")
      end
    end
  end
end
