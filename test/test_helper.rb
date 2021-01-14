require "fileutils"
require "minitest"
require "minitest/autorun"
require "rake"
require "vite_rb"
require "thor"

require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true, slow_count: 5)]

TEST_DIR = File.expand_path(__dir__)
FIXTURE_DIR = File.join(TEST_DIR, "fixtures")
RUBY_TEST_APP = File.join(TEST_DIR, "ruby_test_app")
RAILS_TEST_APP = File.join(TEST_DIR, "rails_test_app")

RAILS_VITE_RB_INITIALIZER = File.join(RAILS_TEST_APP, "config", "initializers", "vite_rb.rb")
RAILS_CONFIG_DIR = File.join(RAILS_TEST_APP, "config", "vite_rb")
RAILS_BUILD_DIR = File.join(RAILS_TEST_APP, "public", "dist")

ROOT_DIR = File.expand_path("..", __dir__)
TEMPLATE_DIR = File.join(ROOT_DIR, "lib", "vite_rb", "templates")

def remove_rails_vite_dirs
  FileUtils.rm_rf(RAILS_CONFIG_DIR)
  FileUtils.rm_rf(RAILS_BUILD_DIR)
  FileUtils.rm_rf(RAILS_VITE_RB_INITIALIZER)
end

def rails_vite_init
  Dir.chdir(RAILS_TEST_APP) { system(%(rails vite:init)) }
end

Minitest.after_run { remove_rails_vite_dirs }
