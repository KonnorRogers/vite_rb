# frozen_string_literal: true

require "socket"
require "vite_rb/env"
require "vite_rb/utils"
require "thor"

module ViteRb
  class Runner < Thor::Group
    include ::Thor::Actions

    attr_reader :config_file

    def initialize
      Env.create_env_variables
    rescue Errno::ENOENT, NoMethodError
      $stdout.puts "Vite configuration not found in #{ViteRb.config.config_dir}"
      $stdout.puts "Please run bundle exec rails generate vite_rb to install Vite"
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
        Utils.detect_port!
        new
        vite_rb_command(env: :development, cmd: :dev)
      end

      private

      def vite_rb_command(env: "", cmd: "")
        env = ENV["NODE_ENV"] || env
        config_file = ViteRb
        command = "NODE_ENV=#{env} yarn run vite #{cmd} --config #{config_file}"
        Rake.sh(command)
      end
    end
  end
end
