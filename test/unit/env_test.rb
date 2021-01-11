require "test_helper.rb"

class EnvTest < Minitest::Test
  def test_sets_env_vars_appropriately
    ViteRb.configure
    ViteRb.config.hostname = "hostname"

    # By default, only sets output_path, mount_dir, port, and hostname
    ViteRb::Env.set_env_variables(ViteRb.config)

    assert_equal ViteRb.config.hostname, ENV["VITE_HOSTNAME"]

    ViteRb.config.hostname = nil
    ViteRb::Env.set_env_variables(ViteRb.config)

    assert ViteRb.config.hostname.nil?
  end
end
