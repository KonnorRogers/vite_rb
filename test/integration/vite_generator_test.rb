# frozen_string_literal: true

require 'rails_helper'
require 'erb'

class ViteRbGeneratorTest < Minitest::Test
  def setup
    remove_rails_vite_dirs
  end

  def teardown
    remove_rails_vite_dirs
  end

  def test_generator_works
    rails_vite_init

    Dir.chdir(RAILS_TEST_APP) { `rails vite:build` }

    context = instance_eval('binding', __FILE__, __LINE__)

    file = File.binread(File.join(TEMPLATE_DIR, 'vite_rb.rb'))
    trim_mode = '-'
    eoutvar = '@output_buffer'

    vite_file = ERB.new(file, trim_mode: trim_mode, eoutvar: eoutvar)

    vite_file = vite_file.result(context)
    assert_equal File.read(RAILS_VITE_RB_INITIALIZER), vite_file

    config_files = %w[vite.config.js postcss.config.js]

    config_files.each do |config_file|
      test_file = File.read(File.join(RAILS_TEST_APP, config_file))
      config_file = File.read(File.join(TEMPLATE_DIR, config_file))

      assert_equal test_file, config_file
    end
  end
end
