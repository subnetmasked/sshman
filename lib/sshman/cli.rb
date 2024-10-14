require 'thor'
require 'tty-table'
require 'tty-prompt'
require_relative 'manager'

module SSHMan
  class CLI < Thor
    desc "list", "List all SSH connections"
    def list
      connections = Manager.list_connections
      table = TTY::Table.new(
        header: ['Name', 'Host', 'User', 'Port', 'Auth Type'],
        rows: connections.map { |c| [c.name, c.host, c.user, c.port, c.auth_type] }
      )
      puts table.render(:unicode, padding: [0, 1])
    end

    desc "add", "Add a new SSH connection"
    def add
      prompt = TTY::Prompt.new
      name = prompt.ask("Enter connection name:")
      host = prompt.ask("Enter host:")
      user = prompt.ask("Enter username:")
      port = prompt.ask("Enter port:", default: "22")
      auth_type = prompt.select("Choose authentication type:", %w(Password SSH\ Key))
      
      if auth_type == "SSH Key"
        ssh_key = prompt.ask("Enter path to SSH key (relative to ~/.ssh/):")
      else
        ssh_key = nil
      end

      connection = Connection.new(name, host, user, port, auth_type, ssh_key)
      Manager.add_connection(connection)
      puts "Connection added successfully!"
    end

    desc "edit NAME", "Edit an existing SSH connection"
    def edit(name)
      connection = Manager.find_connection(name)
      return puts "Connection not found." unless connection

      prompt = TTY::Prompt.new
      connection.host = prompt.ask("Enter new host:", default: connection.host)
      connection.user = prompt.ask("Enter new username:", default: connection.user)
      connection.port = prompt.ask("Enter new port:", default: connection.port)
      connection.auth_type = prompt.select("Choose new authentication type:", %w(Password SSH\ Key), default: connection.auth_type)
      
      if connection.auth_type == "SSH Key"
        connection.ssh_key = prompt.ask("Enter new path to SSH key (relative to ~/.ssh/):", default: connection.ssh_key)
      else
        connection.ssh_key = nil
      end

      Manager.update_connection(connection)
      puts "Connection updated successfully!"
    end

    desc "delete NAME", "Delete an SSH connection"
    def delete(name)
      if Manager.delete_connection(name)
        puts "Connection deleted successfully!"
      else
        puts "Connection not found."
      end
    end

    desc "connect NAME", "Connect to a saved SSH connection"
    def connect(name)
      connection = Manager.find_connection(name)
      return puts "Connection not found." unless connection

      cmd = "ssh #{connection.user}@#{connection.host} -p #{connection.port}"
      cmd += " -i ~/.ssh/#{connection.ssh_key}" if connection.auth_type == "SSH Key"
      
      puts "Connecting to #{connection.name}..."
      exec(cmd)
    end
  end
end
