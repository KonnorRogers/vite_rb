# frozen_string_literal: true

module ViteRb
  # Utilities for working with ViteRb
  module Utils
    class << self
      def development?
        ENV['VITE_RB_MODE'] == 'development'
      end

      def production?
        ENV['VITE_RB_MODE'] == 'production'
      end

      def testing?
        ENV['VITE_RB_MODE'] == 'testing'
      end
    end
  end
end
