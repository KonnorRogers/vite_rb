# frozen_string_literal: true

require 'vite_rb/configuration'
require 'vite_rb/env'
require 'vite_rb/generator'
require 'vite_rb/helpers'
require 'vite_rb/proxy'
require 'vite_rb/utils'
require 'vite_rb/manifest'
require 'vite_rb/dev_server'

# ViteRb is the top-level module for interacting with the Vite ESM bundler.
module ViteRb
  class << self
    attr_accessor :config
    attr_writer :manifest

    def configure
      self.config ||= Configuration.new
      yield(config) if block_given?
    end

    def manifest
      @manifest ||= Manifest.new(config.manifest_path)
    end
  end
end

require 'vite_rb/version'
require 'vite_rb/runner'
require 'vite_rb/engine' if defined?(Rails)
