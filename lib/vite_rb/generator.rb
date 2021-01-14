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
    ].freeze

    def self.source_root
      TEMPLATES
    end

    def create_initializer_file
      source = "vite_rb.rb"

      destination = find_destination

      # Creates a config/initializers/vite_rb.rb file
      say "\n\nCreating initializer file at #{destination}...\n\n", :magenta
      template source, destination
    end

    def create_config_files
      destination = find_destination
      Rake.mkdir_p destination

      say "\n\nCreating config files @ #{destination}...\n\n", :magenta
      CONFIG_FILES.each do |filename|
        template filename, File.join(destination, filename)
      end
    end

    def create_vite_files
      destination = find_destination

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
      return system("yarn add vite_rb file:../../") if ENV["VITE_RB_TEST"] == "true"

      system("yarn add vite_rb")
    end

    def self.init
      new.init
    end

    private

    def find_destination
      if Utils.rails?
        Rails.root.join("config/initializers", target)
      else
        File.join("config/initializers", target)
      end
    end
  end
end
