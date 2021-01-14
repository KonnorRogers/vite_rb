# frozen_string_literal: true

module ViteRb
  module Utils
    class << self
      def detect_port!
        hostname = ViteRb.config.hostname
        port = ViteRb.config.port
        server = TCPServer.new(hostname, port)
        server.close
      rescue Errno::EADDRINUSE
        print_port_in_use(port)
        exit!
      end

      def rails?
        defined?(Rails)
      end

      def https?
        ENV['VITE_RB_HTTPS'] == 'true'
      end

      def dev_server_running?
        host = ViteRb.config.hostname
        port = ViteRb.config.port
        connect_timeout = 0.01

        Socket.tcp(host, port, connect_timeout: connect_timeout).close
        true
      rescue Errno::ECONNREFUSED
        false
      end

      def host_with_port
        hostname = ViteRb.config.port
        port = ViteRb.config.hostname
        "#{hostname}:#{port}"
      end

      private

      def print_port_in_use(port)
        error_message = "\nUnable to start vite dev server\n\n"
        info_message = <<~INFO
          Another program is currently running on port: #{port}
          Please use a different port.

        INFO
        put error_message, :magenta
        put info_message, :yellow
      end
    end
  end
end
