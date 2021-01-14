# frozen_string_literal: true

module ViteRb
  # Sets the appropriately prefixed ENV variables with VITE_RB
  class Env
    ENV_PREFIX = 'VITE_RB'

    class << self
      def create_env_variables(config = ViteRb.config)
        config.options.each { |key, value| set_env(key, value) }
      end

      private

      def set_env(env_var, value)
        return if value.nil?

        ENV["#{ENV_PREFIX}_#{env_var.upcase}"] ||= value.to_s
      end
    end
  end
end
