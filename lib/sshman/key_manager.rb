require 'openssl'
require 'fileutils'

module Sshman
  class KeyManager
    SSH_DIR = File.expand_path("~/.ssh")

    def self.generate_key
      FileUtils.mkdir_p(SSH_DIR)

      print "Enter bit size (default 2048): "
      bit_size = gets.chomp.to_i
      bit_size = 2048 if bit_size <= 0

      print "Enter key name (default id_rsa): "
      key_name = gets.chomp.strip
      key_name = "id_rsa" if key_name.empty?

      private_key_path = File.join(SSH_DIR, key_name)
      public_key_path = "#{private_key_path}.pub"

      print "Enter passphrase (leave blank for no passphrase): "
      passphrase = gets.chomp.strip

      key = OpenSSL::PKey::RSA.new(bit_size)
      cipher = OpenSSL::Cipher.new('AES-128-CBC') if passphrase != ""
      private_key = passphrase.empty? ? key.to_pem : key.export(cipher, passphrase)
      public_key = "ssh-rsa #{[key.public_key.to_der].pack('m0')}"

      File.write(private_key_path, private_key)
      File.write(public_key_path, public_key)
      File.chmod(0600, private_key_path)
      File.chmod(0644, public_key_path)

      puts "#{GREEN}SSH keys generated successfully! Private key: #{private_key_path}, Public key: #{public_key_path}#{RESET_COLOR}"
    end
  end
end
