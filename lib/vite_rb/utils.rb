# frozen_string_literal: true

module ViteRb
  # Utilities for working with ViteRb
  module Utils
    class << self
      def rails?
        defined?(Rails)
      end

      def detect_port!
        server = TCPServer.new(host, port)
        server.close
      rescue Errno::EADDRINUSE
        print_port_in_use(host_with_port)
        exit!
      end

      def host_with_port
        config = ViteRb.config
        "#{config.host}:#{config.port}"
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
