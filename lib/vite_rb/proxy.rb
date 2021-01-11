# frozen_string_literal: true

require "rack/proxy"
require "socket"
require "vite/utils"

module ViteRb
  # Proxy server for Vite
  class Proxy < Rack::Proxy
    def initialize(app = nil, opts = {})
      opts[:streaming] = false if Rails.env.test? && !opts.key?(:streaming)
      super
    end

    def perform_request(env)
      output_dir = %r{/#{ViteRb.config.output_dir}/}

      if env["PATH_INFO"].start_with?(output_dir) && Utils.dev_server_running?
        env["HTTP_HOST"] = env["HTTP_X_FORWARDED_HOST"] = ViteRb
        env["HTTP_X_FORWARDED_SERVER"] = Utils.host_with_port
        env["HTTP_PORT"] = env["HTTP_X_FORWARDED_PORT"] = ViteRb
        env["HTTP_X_FORWARDED_PROTO"] = env["HTTP_X_FORWARDED_SCHEME"] = "http"

        unless Utils.https?
          env["HTTPS"] = env["HTTP_X_FORWARDED_SSL"] = "off"
        end

        env["SCRIPT_NAME"] = ""
        super(env)
      else
        @app.call(env)
      end
    end
  end
end
