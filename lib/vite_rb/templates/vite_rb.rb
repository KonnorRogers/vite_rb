require "pathname"

<%- if defined?(Rails) -%>
Rails.application.config.middleware.insert_before 0, ViteRb::Proxy, {ssl_verify_none: true}
<%- end -%>

ViteRb.configure do |vite|
  # Top level of the project
  # This will not be passed to your vite config
  <%- if defined?(Rails) -%>
    vite.top_level = Rails.root
  <%- else -%>
    vite.top_level = Pathname.new(Dir.pwd)
  <%- end -%>

  # Root of all js files
  vite.root = vite.top_level.join("app/vite")

  # Where to build your files to
  vite.out_dir = vite.top_level.join("public/dist").relative_path_from(vite.root)

  # Where non-js files will go
  # Will be appended to your #{vite.out_dir}
  vite.assets_dir = "assets"

  # Base public path when served in production. Note the path should start and end with /
  vite.base = "/"

  vite.host = "localhost"
  vite.port = "4035"

  # Generates a manifest of your hashed files for production
  vite.manifest = true

  # Non-vite config options (not directly sent to vite.config.js

  # Entrypoint files (like packs)
  vite.entrypoints_dir = vite.root.join("entrypoints")

  vite.config_file = "vite.config.js"
end

<%- if defined?(Rails) -%>
ActiveSupport.on_load :action_controller do
  ActionController::Base.helper ViteRb::Helpers
end

ActiveSupport.on_load :action_view do
  include ViteRb::Helpers
end
<%- end -%>
