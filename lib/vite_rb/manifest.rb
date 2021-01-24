# frozen_string_literal: true

require 'json'

module ViteRb
  # The basic class for reading from the manifest.json
  class Manifest
    attr_reader :hash

    def initialize(file)
      @hash = load_manifest(file)
    end

    def reload(manifest_file = ViteRb.config.manifest_file)
      @hash = load_manifest(manifest_file)
    end

    def find_file(file_name)
      @hash.fetch(file_name).fetch('file')
    rescue KeyError
      nil
    end

    private

    def load_manifest(manifest_file = ViteRb.config.manifest_file)
      @hash = JSON.parse(File.read(manifest_file))
    end
  end
end
