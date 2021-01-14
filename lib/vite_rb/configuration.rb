# frozen_string_literal: true

module ViteRb
  # Configuration Object for ViteRb
  class Configuration
    attr_reader :options

    def initialize
      @options = {}
      yield(self) if block_given?
    end

    # Allows dynamic definition of getters and setters
    # The setter must be the value used first.
    # @example
    #   ViteRb.config.fake_attr # => Raises an error
    #   ViteRb.config.fake_attr = "stuff"
    #   ViteRb.config.fake_attr # => "stuff"
    def method_missing(method_name, *args, &block)
      method_string = method_name.to_s

      key = method_string.slice(0...-1).to_sym

      # Check if the method missing an "attr=" method
      return @options[method_name.to_sym] unless method_string.end_with?("=")

      @options[key] = args[0]
    rescue MethodMissing
      # Raise error as normal, nothing to see here
      super(method_name, *args, &block)
    end

    # rubocop:enable Style/MethodMissingSuper Metrics/MethodLength

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?("=") || super
    end
  end
end
