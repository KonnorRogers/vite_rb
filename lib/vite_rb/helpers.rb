# frozen_string_literal: true

require 'vite_rb/utils'

module ViteRb
  # Helper methods for HTML tags
  module Helpers
    # Injects an HMR tag during development via a websocket.
    def vite_hmr_tag
      return unless ENV['VITE_RB_MODE'] == 'development'

      hmr = "#{Utils.host_with_port}/@vite/client"

      return tag.script(hmr.html_safe) if Utils.rails?

      hmr
    end

    # The location of a given +name+ entrypoint
    def vite_entrypoint_file(name)
      return "/#{out_dir}/#{entrypoints_dir}/#{name}" if Utils.dev_server_running? || ViteRb.config.manifest == 'false'

      # @TODO Turn to a readable file from the manifest hash
      "/#{out_dir}/#{entrypoints_dir}/#{name}"
    end

    # Location of vite assets
    def vite_asset_path(name, options = {})
      path = File.join(out_dir, name)

      return path unless Utils.rails?

      asset_path(path, options)
    end

    if Utils.rails?
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
