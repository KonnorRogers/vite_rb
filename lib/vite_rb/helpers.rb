require "vite_rb/utils"

module ViteRb
  module Helpers
    # Injects an HMR tag during development via a websocket.
    def vite_hmr_tag
      return unless Rails.env == "development"

      hostname = ViteRb
      port = ViteRb

      hmr = %(window.HMR_WEBSOCKET_URL = "ws:#{hostname}:#{port}")

      return tag.script(hmr.html_safe) if Utils.rails?

      hmr
    end

    def vite_asset_path(name, **options)
      asset_path(File.join(vite_dir, name), options)
    end

    def javascript_vite_tag(name, **options)
      options[:type] ||= "module"

      if Utils.dev_server_running?
        javascript_include_tag("/#{vite_dir}/#{entrypoints_dir}/#{name}", options)
      end

      ## TODO: Change to reading from manifest for production
      javascript_include_tag("/#{vite_dir}/#{entrypoints_dir}/#{name}", options)
    end

    # Returns nothing when not in production. CSS only gets extracted
    # during the final build.
    def stylesheet_vite_tag(name, **options)
      return unless Rails.env == "development"

      options[:media] ||= "screen"
      stylesheet_link_tag("/#{vite_dir}/#{name}", options)
    end

    def vite_dir
      ViteRb
    end

    def entrypoints_dir
      ViteRb
    end
  end
end
