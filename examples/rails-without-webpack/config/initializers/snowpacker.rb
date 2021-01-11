Rails.application.config.middleware.insert_before 0, ViteRb

ViteRb.configure do |vite|
  # Where to build snowpack to (out dir)
  vite.build_dir = "public"

  # url to use for assets IE: /vite/xyz.css, gets built to public/frontend
  vite.output_dir = "vite"

  # Where to find the config directory
  vite.config_path = Rails.root.join("config", "vite")
  vite.mount_path = Rails.root.join("app", "vite")
  vite.manifest_file = Rails.root.join(vite.build_dir, vite.output_dir, "manifest.json")

  # Where to find the snowpack config file
  vite.config_file = File.join(vite.config_path, "vite.config.js")

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

ActiveSupport.on_load :action_controller do
  ActionController::Base.helper ViteRb
end

ActiveSupport.on_load :action_view do
  include ViteRb
end
