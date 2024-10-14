# lib/sshman/connection.rb
module SSHMan
  class Connection
    attr_accessor :name, :host, :user, :port, :auth_type, :ssh_key

    def initialize(name, host, user, port, auth_type, ssh_key = nil)
      @name = name
      @host = host
      @user = user
      @port = port
      @auth_type = auth_type
      @ssh_key = ssh_key
    end

    def to_h
      {
        name: @name,
        host: @host,
        user: @user,
        port: @port,
        auth_type: @auth_type,
        ssh_key: @ssh_key
      }
    end

    def self.from_h(hash)
      new(hash[:name], hash[:host], hash[:user], hash[:port], hash[:auth_type], hash[:ssh_key])
    end
  end
end
