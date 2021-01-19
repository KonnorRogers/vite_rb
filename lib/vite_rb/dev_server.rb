# frozen_string_literal: true

module ViteRB
  # The dev server used for ViteRb
  class DevServer
    def self.running?
      connect_timeout = 0.01

      config = ViteRb.config
      Socket.tcp(config.host, config.port, connect_timeout: connect_timeout).close
      true
    rescue Errno::ECONNREFUSED
      false
    end
  end
end
