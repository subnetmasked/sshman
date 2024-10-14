# lib/sshman/manager.rb
require 'yaml'
require_relative 'connection'

module SSHMan
  class Manager
    CONFIG_FILE = File.expand_path('~/.sshman.yml')

    class << self
      def list_connections
        load_connections
      end

      def add_connection(connection)
        connections = load_connections
        connections << connection
        save_connections(connections)
      end

      def update_connection(updated_connection)
        connections = load_connections
        index = connections.index { |c| c.name == updated_connection.name }
        connections[index] = updated_connection if index
        save_connections(connections)
      end

      def delete_connection(name)
        connections = load_connections
        initial_count = connections.count
        connections.reject! { |c| c.name == name }
        save_connections(connections)
        initial_count != connections.count
      end

      def find_connection(name)
        load_connections.find { |c| c.name == name }
      end

      private

      def load_connections
        return [] unless File.exist?(CONFIG_FILE)

        YAML.load_file(CONFIG_FILE).map { |hash| Connection.from_h(hash) }
      end

      def save_connections(connections)
        File.write(CONFIG_FILE, connections.map(&:to_h).to_yaml)
      end
    end
  end
end
