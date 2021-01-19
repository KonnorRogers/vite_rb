# frozen_string_literal: true

module ViteRB
  # The dev server used for ViteRb
  class DevServer
    class << self
      def running?
        connect_timeout = 0.01

        Socket.tcp(host, port, connect_timeout: connect_timeout).close
        true
      rescue Errno::ECONNREFUSED
        false
      end

      def detect_port!
        detect_port { exit! }
      end

      private

      def detect_port
        server = TCPServer.new(DevServer.host, DevServer.port)
        server.close
      rescue Errno::EADDRINUSE
        print_port_in_use(Utils.host_with_port)
        yield
      end

      def host
        ViteRb.config.host
      end

      def port
        ViteRb.config.port
      end

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
