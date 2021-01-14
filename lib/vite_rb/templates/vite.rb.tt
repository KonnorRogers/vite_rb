<%- if defined?(Rails) -%>
Rails.application.config.middleware.insert_before 0, ViteRb::Proxy, {ssl_verify_none: true}
<%- end -%>

ViteRb.configure do |vite|
  # Where to build vite to (out dir)
  vite.build_dir = "public"

  # url to use for assets IE: /vite/xyz.css, gets built to public/frontend
  vite.out_dir = "vite"

  # Where to find the config directory
  <%- if defined?(Rails) -%>
  vite.config_path = Rails.root.join("config", "vite")
  vite.mount_path = Rails.root.join("app", "vite")
  vite.manifest_file = Rails.root.join(vite.build_dir, vite.output_dir, "manifest.json")
  <%- else -%>
  vite.config_path = File.join("config", "vite")
  vite.mount_path = File.join("app", "vite")
  vite.manifest_file = File.join(vite.build_dir, vite.output_dir, "manifest.json")
  <%- end -%>

  # Where to find the snowpack config file
  vite.config_file = File.join(vite.config_path, "snowpack.config.js")

  # Where to find the babel config file
  vite.babel_config_file = File.join(vite.config_path, "babel.config.js")

  # Where to find the postcss config file
  vite.postcss_config_file = File.join(vite.config_path, "postcss.config.js")

  # Where to find your snowpack files
  vite.entrypoints_dir = "entrypoints"

  # What port to run vite with
  vite.port = "4035"

  # What hostname to use
  vite.hostname = "localhost"

  # Whether or not to use https
  # https://www.snowpack.dev/#https%2Fhttp2
  vite.https = false
end

<%- if defined?(Rails) -%>
ActiveSupport.on_load :action_controller do
  ActionController::Base.helper ViteRb::Helpers
end

ActiveSupport.on_load :action_view do
  include ViteRb::Helpers
end
<%- end -%>
