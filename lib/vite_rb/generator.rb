# frozen_string_literal: true

require 'thor'
require 'vite_rb/utils'

module ViteRb
  # The generator for ViteRb for templates
  class Generator < Thor::Group
    include Thor::Actions
    extend Utils

    TEMPLATES = File.join(File.expand_path(__dir__), 'templates')
    CONFIG_FILES = %w[
      vite.config.js
      postcss.config.js
    ].freeze

    def self.source_root
      TEMPLATES
    end

    def create_initializer_file
      source = 'vite_rb.rb'

      destination = Generator.find_destination("config/initializers/#{source}")

      # Creates a config/initializers/vite_rb.rb file
      say "\n\nCreating initializer file at #{destination}...\n\n", :magenta
      template source, destination
    end

    def create_config_files
      destination = Generator.find_destination

      say "\n\nCreating config files @ #{destination}...\n\n", :magenta
      CONFIG_FILES.each do |filename|
        template filename, File.join(destination, filename)
      end
    end

    def create_vite_files
      destination = Generator.find_destination('app/vite')

      Rake.mkdir_p(destination)

      say "\n\nCreating vite files...\n\n", :magenta

      directory 'vite', destination
    end

    def init
      create_initializer_file
      create_config_files
      create_vite_files
      add_vite

      say 'Finished initializing vite', :green
    end

    def add_vite
      # This is used for local testing
      return system('yarn add vite_rb file:../../') if ENV['VITE_RB_TEST'] == 'true'

      system('yarn add vite_rb')
    end

    def self.init
      new.init
    end

    def self.find_destination(*paths)
      return Rails.root.join(*paths) if defined?(Rails)

      File.join(Dir.pwd, *paths)
    end
  end
end
