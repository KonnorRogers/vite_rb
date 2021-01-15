# Rails.application.config.middleware.insert_before 0, ViteRb::Proxy, {ssl_verify_none: true}

ViteRb.configure do |vite|
  # Root of the project
  vite.root = Rails.root.join("app/vite").to_s

  # Where to build your files to
  vite.out_dir = Rails.root.join("public/dist")

  # Where non-js files will go
  vite.assets_dir = "assets"

  # Base public path when served in production. Note the path should start and end with /
  vite.base = "/"

  vite.host = "localhost"
  vite.port = "4035"

  # Generates a manifest of your hashed files for production
  vite.manifest = true

  # Non-vite config options (not directly sent to vite.config.js

  # Entrypoint files (like packs)
  vite.entrypoints_dir = File.join(vite.root, "entrypoints")

  vite.config_file = "vite.config.js"

  vite.proxy_url = "app/vite/entrypoints"
end

ActiveSupport.on_load :action_controller do
  ActionController::Base.helper ViteRb::Helpers
end

ActiveSupport.on_load :action_view do
  include ViteRb::Helpers
end
