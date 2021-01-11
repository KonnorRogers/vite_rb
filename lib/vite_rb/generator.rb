require "thor"
require "vite_rb/utils"

module ViteRb
  class Generator < Thor::Group
    include Thor::Actions
    extend Utils

    TEMPLATES = File.join(File.expand_path(__dir__), "templates")
    CONFIG_FILES = %w[
      vite.config.js
      postcss.config.js
    ]

    def self.source_root
      TEMPLATES
    end

    def create_initializer_file
      target = "vite.rb"
      source = "#{target}.tt"

      destination = File.join("config", "initializers", target)

      if Utils.rails?
        destination = Rails.root.join("config", "initializers", target)
      end

      # Creates a config/initializers/vite.rb file
      say "\n\nCreating initializer file at #{destination}...\n\n", :magenta
      template source, destination
    end

    def create_config_files
      destination = File.join("config", "vite")

      if Utils.rails?
        destination = Rails.root.join("config", "vite")
      end

      Rake.mkdir_p destination

      say "\n\nCreating config files @ #{destination}...\n\n", :magenta
      CONFIG_FILES.each do |filename|
        template filename, File.join(destination, filename)
      end
    end

    def create_vite_files
      destination = File.join("app", "vite")

      if Utils.rails?
        destination = Rails.root.join("app", "vite")
      end
      say "\n\nCreating vite files...\n\n", :magenta

      directory "vite", destination
    end

    def init
      create_initializer_file
      create_config_files
      create_vite_files
      add_vite

      say "Finished initializing vite", :green
    end

    def add_vite
      if ENV["VITE_RB_TEST"] == "true"
        return system("yarn add vite_rb file:../../")
      end

      system("yarn add vite_rb")
    end

    def self.init
      new.init
    end
  end
end
