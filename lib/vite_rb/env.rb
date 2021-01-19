# frozen_string_literal: true

module ViteRb
  # Sets the appropriately prefixed ENV variables with VITE_RB
  class Env
    ENV_PREFIX = 'VITE_RB'

    class << self
      def development?
        current_mode == 'development'
      end

      def production?
        current_mode == 'production'
      end

      def testing?
        current_mode == 'testing'
      end

      def create_env_variables(config = ViteRb.config)
        config.options.each do |key, value|
          set_env(key, value)
        end
      end

      private

      def set_env(var, value)
        env_var = current_env_var(var)
        ENV[env_var] = ENV.fetch(env_var, value&.to_s)
      end

      def current_mode
        current_env_var('MODE')
      end

      def current_env_var(var)
        "#{ENV_PREFIX}_#{var.upcase}"
      end
    end
  end
end
