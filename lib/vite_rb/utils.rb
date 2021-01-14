# frozen_string_literal: true

module ViteRb
  # Utilities for working with ViteRb
  module Utils
    class << self
      def detect_port!
        server = TCPServer.new(host, port)
        server.close
      rescue Errno::EADDRINUSE
        print_port_in_use(host_with_port)
        exit!
      end

      def rails?
        defined?(Rails)
      end

      def https?
        ENV['VITE_RB_HTTPS'] == 'true'
      end

      def host
        ViteRb.config.host
      end

      def port
        ViteRb.config.port
      end

      def dev_server_running?
        connect_timeout = 0.01

        Socket.tcp(host, port, connect_timeout: connect_timeout).close
        true
      rescue Errno::ECONNREFUSED
        false
      end

      def host_with_port
        "#{host}:#{port}"
      end

      private

      def print_port_in_use(port)
        error_message = "\nUnable to start vite dev server\n\n"
        info_message = <<~INFO
          Another program is currently at this location: #{port}
          Please use a different port.
        INFO

        say error_message, :magenta
        say info_message, :yellow
      end
    end
  end
end
