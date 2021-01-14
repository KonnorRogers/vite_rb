require "rails_helper"
require "erb"

class ViteRbGeneratorTest < Minitest::Test
  def setup
    remove_rails_vite_dirs
  end

  def teardown
    remove_rails_vite_dirs
  end

  def test_generator_works
    capture_subprocess_io { rails_vite_init }

    output = Dir.chdir(RAILS_TEST_APP) { `rails vite:build` }

    assert_match %r{Build Complete!}, output

    context = instance_eval("binding", __FILE__, __LINE__)

    file = File.binread(File.join(TEMPLATE_DIR, "vite.rb.tt"))
    trim_mode = "-"
    eoutvar = "@output_buffer"

    vite_file = nil

    # Account for ERB argument deprecation from 2.5 -> 2.6
    # https://bugs.ruby-lang.org/issues/14256

    vite_file = if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.6.0")
      ERB.new(file, trim_mode: trim_mode, eoutvar: eoutvar)
    else
      ERB.new(file, trim_mode: trim_mode, eoutvar: eoutvar)
    end

    vite_file = vite_file.result(context)
    assert_equal File.read(RAILS_VITE_INITIALIZER), vite_file

    config_files = %w[vite.config.js postcss.config.js]

    config_files.each do |config_file|
      test_file = File.read(File.join(RAILS_CONFIG_DIR, config_file))
      config_file = File.read(File.join(TEMPLATE_DIR, config_file))

      assert_equal test_file, config_file
    end
  end
end
