# frozen_string_literal: true

require 'vite_rb/utils'

module ViteRb
  # Helper methods for HTML tags
  module Helpers
    def vite_hmr_path
      return unless Env.development?

      "#{DevServer.host_with_port}/@vite/client"
    end

    # Injects an HMR tag during development via a websocket.
    def vite_hmr_tag
      path = vite_hmr_path

      return tag.script(path.html_safe) if defined?(Rails)

      path
    end

    # The location of a given +name+ entrypoint
    def vite_entrypoint_file(name)
      return "#{out_dir}/#{entrypoints_dir}/#{name}" if DevServer.running? || ViteRb.config.manifest == 'false'

      # @TODO Turn to a readable file from the manifest hash
      "#{out_dir}/#{entrypoints_dir}/#{name}"
    end

    # Location of vite assets
    def vite_asset_path(name, options = {})
      path = File.join(out_dir, name)

      return path unless defined?(Rails)

      asset_path(path, options)
    end

    def javascript_vite_tag(name, options = {})
      options[:type] ||= 'module'
      javascript_include_tag(vite_entrypoint_file(name), options)
    end

    # Returns nothing when not in production. CSS only gets extracted
    # during the final build.
    def stylesheet_vite_tag(name, options = {})
      options[:media] ||= 'screen'
      stylesheet_link_tag("/#{out_dir}/#{name}", options)
    end

    private

    def out_dir
      ViteRb.config.out_dir
    end

    def entrypoints_dir
      ViteRb.config.entrypoints_dir
    end
  end
end
