# frozen_string_literal: true

require 'json'

module ViteRb
  # The basic class for reading from the manifest.json
  class Manifest
    VALID_TYPES = %i[js js.map css css.map].freeze

    attr_reader :hash

    def initialize(file)
      @hash = load_manifest(file)
    end

    def reload(manifest_file = ViteRb.config.manifest_file)
      @hash = load_manifest(manifest_file)
    end

    def find_entrypoint(file_name, type)
      @hash[:entrypoints][file_name.to_sym][type.to_sym]
    end

    def find_file(file_name)
      @hash[file_name.to_sym]
    end

    def find_chunk(chunk_name)
      @hash[:chunks][chunk_name.to_sym][:js]
    end

    def self.valid_type?(type)
      VALID_TYPES.include?(type)
    end

    private

    def load_manifest(manifest_file = ViteRb.config.manifest_file)
      @hash = JSON.parse(File.read(manifest_file), symbolize_names: true)
    end
  end
end
