# frozen_string_literal: true

require 'test_helper'

class EnvTest < Minitest::Test
  ENV_VARS = %w[
    ROOT
    ENTRYPOINTS_DIR
    BASE_URL
    OUT_DIR
    ASSETS_DIR
    HOST
    HTTPS
    PORT
    MANIFEST
  ].freeze

  def test_method_missing_works
    str = "Hi"
    ViteRb.configure { |config| config.host = str }

    assert_equal ViteRb.config.host, str
  end

  def test_sets_env_vars_appropriately
    ViteRb.configure

    ENV_VARS.each do |var|
      assert_nil ENV["VITE_RB_#{var}"]
      assert_nil ViteRb.config.send(var)
      assert_nil ViteRb.config.send(var.to_sym)
    end

    str = "Yo"
    ViteRb.config.host = str
    ViteRb::Env.create_env_variables(ViteRb.config)

    assert_equal ENV["VITE_RB_HOST"], "Yo"


    ViteRb.config.hostname = nil
    ViteRb::Env.create_env_variables(ViteRb.config)

    assert_nil ViteRb.config.hostname
  end
end
