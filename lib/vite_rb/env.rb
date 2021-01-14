# frozen_string_literal: true

module ViteRb
  # Sets the appropriately prefixed ENV variables with VITE_RB
  class Env
    ENV_PREFIX = 'VITE_RB'

    class << self
      def create_env_variables(config = ViteRb.config)
        instance_variables.each do |var|
          value = config.instance_variable_get(var)

          # .slice removes the "@" from beginning of string
          var = var.to_s.upcase.slice(1..-1)

          set_env(var, value)
        end
      end

      private

      def set_env(env_var, value)
        return if value.nil?

        ENV["#{ENV_PREFIX}_#{env_var}"] ||= value.to_s
      end
    end
  end
end
