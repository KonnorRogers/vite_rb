# frozen_string_literal: true

require 'rack/proxy'
require 'socket'
require 'vite_rb/utils'

module ViteRb
  # Proxy server for Vite
  class Proxy < Rack::Proxy
    # :reek:FeatureEnvy
    def initialize(app = nil, opts = {})
      opts[:streaming] = false if Rails.env.test? && !opts.key?(:streaming)
      super
    end

    def perform_request(env)
      out_dir = %r{/#{ViteRb.config.proxy_url}/}

      if env['PATH_INFO'].start_with?(out_dir) && DevServer.running?
        Proxy.rewrite_host(env)
        Proxy.rewrite_headers(env)
        super(env)
      else
        @app.call(env)
      end
    end

    class << self
      private

      def rewrite_host(env)
        config = ViteRb.config
        env['HTTP_HOST'] = env['HTTP_X_FORWARDED_HOST'] = config.host
        env['HTTP_X_FORWARDED_SERVER'] = Utils.host_with_port
        env['HTTP_PORT'] = env['HTTP_X_FORWARDED_PORT'] = config.port
      end

      def rewrite_headers(env)
        env['HTTP_X_FORWARDED_PROTO'] = env['HTTP_X_FORWARDED_SCHEME'] = 'http'
        env['HTTPS'] = env['HTTP_X_FORWARDED_SSL'] = 'off' unless ViteRb.config.https?
        env['SCRIPT_NAME'] = ''
      end
    end
  end
end
