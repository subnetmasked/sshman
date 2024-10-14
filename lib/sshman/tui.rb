# lib/sshman/tui.rb
require 'tty-prompt'
require_relative 'manager'
require_relative 'connection'

module SSHMan
  class TUI
    def initialize
      @prompt = TTY::Prompt.new
    end

    def start
      loop do
        case main_menu
        when 'List Connections'
          list_connections
        when 'Add Connection'
          add_connection
        when 'Edit Connection'
          edit_connection
        when 'Delete Connection'
          delete_connection
        when 'Connect'
          connect
        when 'Exit'
          break
        end
      end
    end

    private

    def main_menu
      @prompt.select("SSHMan - Main Menu") do |menu|
        menu.choice 'List Connections'
        menu.choice 'Add Connection'
        menu.choice 'Edit Connection'
        menu.choice 'Delete Connection'
        menu.choice 'Connect'
        menu.choice 'Exit'
      end
    end

    def list_connections
      connections = Manager.list_connections
      if connections.empty?
        puts "No connections found."
      else
        table = TTY::Table.new(
          header: ['Name', 'Host', 'User', 'Port', 'Auth Type'],
          rows: connections.map { |c| [c.name, c.host, c.user, c.port, c.auth_type] }
        )
        puts table.render(:unicode, padding: [0, 1])
      end
      @prompt.keypress("Press any key to continue")
    end

    def add_connection
      name = @prompt.ask("Enter connection name:")
      host = @prompt.ask("Enter host:")
      user = @prompt.ask("Enter username:")
      port = @prompt.ask("Enter port:", default: "22")
      auth_type = @prompt.select("Choose authentication type:", %w(Password SSH\ Key))
      
      if auth_type == "SSH Key"
        ssh_key = @prompt.ask("Enter path to SSH key (relative to ~/.ssh/):")
      else
        ssh_key = nil
      end

      connection = Connection.new(name, host, user, port, auth_type, ssh_key)
      Manager.add_connection(connection)
      puts "Connection added successfully!"
      @prompt.keypress("Press any key to continue")
    end

    def edit_connection
      connections = Manager.list_connections
      if connections.empty?
        puts "No connections found."
        return
      end

      name = @prompt.select("Select connection to edit:", connections.map(&:name))
      connection = Manager.find_connection(name)

      connection.host = @prompt.ask("Enter new host:", default: connection.host)
      connection.user = @prompt.ask("Enter new username:", default: connection.user)
      connection.port = @prompt.ask("Enter new port:", default: connection.port)
      connection.auth_type = @prompt.select("Choose new authentication type:", %w(Password SSH\ Key), default: connection.auth_type)
      
      if connection.auth_type == "SSH Key"
        connection.ssh_key = @prompt.ask("Enter new path to SSH key (relative to ~/.ssh/):", default: connection.ssh_key)
      else
        connection.ssh_key = nil
      end

      Manager.update_connection(connection)
      puts "Connection updated successfully!"
      @prompt.keypress("Press any key to continue")
    end

    def delete_connection
      connections = Manager.list_connections
      if connections.empty?
        puts "No connections found."
        return
      end

      name = @prompt.select("Select connection to delete:", connections.map(&:name))
      if Manager.delete_connection(name)
        puts "Connection deleted successfully!"
      else
        puts "Failed to delete connection."
      end
      @prompt.keypress("Press any key to continue")
    end

    def connect
      connections = Manager.list_connections
      if connections.empty?
        puts "No connections found."
        return
      end

      name = @prompt.select("Select connection to connect:", connections.map(&:name))
      connection = Manager.find_connection(name)

      cmd = "ssh #{connection.user}@#{connection.host} -p #{connection.port}"
      cmd += " -i ~/.ssh/#{connection.ssh_key}" if connection.auth_type == "SSH Key"
      
      puts "Connecting to #{connection.name}..."
      system(cmd)
    end
  end
end
