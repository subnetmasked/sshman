require 'logger'
require_relative 'constants'
require_relative 'version'
require_relative 'server_manager'
require_relative 'utils'

module Sshman
  class CLI
    LOGGER = Logger.new(File.expand_path('~/.sshman.log'))

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
        new.connect_to_server(argv[1])
      when 'help'
        new.display_help
      when 'version'
        new.version
      else
        puts "Unknown command: #{argv[0]}. Use 'sshman help' for a list of commands."
      end
    end

    def version
      puts "sshman version #{Sshman::VERSION}"
    end

    def self.start_interactive
      new.main
    end

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

    def ensure_csv_file
      Sshman::Utils.ensure_csv_file
    end

    def display_help
      Sshman::Utils.display_help
    end

    def list_servers
      Sshman::ServerManager.list_servers
    end

    def add_server
      Sshman::ServerManager.add_server
    end

    def edit_server
      Sshman::ServerManager.edit_server
    end

    def delete_server
      Sshman::ServerManager.delete_server
    end

    def connect_to_server(alias_name = nil)
      Sshman::ServerManager.connect_to_server(alias_name)
    end
  end
end
