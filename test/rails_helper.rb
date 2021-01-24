# frozen_string_literal: true

require 'rails'
require 'test_helper'

ENV['RAILS_ENV'] = 'test'

RAILS_TEST_APP = File.join(TEST_DIR, 'rails_test_app')
RAILS_VITE_RB_INITIALIZER = File.join(RAILS_TEST_APP, 'config', 'initializers', 'vite_rb.rb')
RAILS_BUILD_DIR = File.join(RAILS_TEST_APP, 'public', 'dist')

def remove_rails_vite_dirs
  FileUtils.rm_rf(RAILS_BUILD_DIR)
  FileUtils.rm_rf(RAILS_VITE_RB_INITIALIZER)
end

def rails_vite_init
  Dir.chdir(RAILS_TEST_APP) { `rails vite:init` }
end

Minitest.after_run { remove_rails_vite_dirs }
