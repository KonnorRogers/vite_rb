# frozen_string_literal: true

require 'socket'
require 'vite_rb/env'
require 'vite_rb/utils'
require 'thor'

module ViteRb
  # Rails runner. This should be moved elsewhere
  class Runner < Thor::Group
    include ::Thor::Actions

    attr_reader :config_file

    def initialize
      super
      Env.create_env_variables
    rescue Errno::ENOENT, NoMethodError
      $stdout.puts "Vite configuration not found at #{ViteRb.config.config_path}"
      $stdout.puts 'Please run bundle exec rails vite:init to install Vite'
      exit!
    end

    class << self
      # Build for production
      def build
        new
        vite_rb_command(env: :production, cmd: :build)
      end

      # Serve for development
      def dev
        DevServer.detect_port!
        new

        # vite is run as `vite`
        vite_rb_command(env: :development)
      end

      private

      def vite_rb_command(env: '', cmd: '')
        env ||= ENV['NODE_ENV']
        command = "NODE_ENV=#{env} yarn run vite #{cmd} --config ./#{ViteRb.config.config_file}"
        Rake.sh(command)
      end
    end
  end
end
