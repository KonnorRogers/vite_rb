# frozen_string_literal: true

require 'fileutils'
require 'minitest'
require 'minitest/autorun'
require 'rake'
require 'vite_rb'
require 'thor'

require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true, slow_count: 5)]

TEST_DIR = File.expand_path(__dir__)
FIXTURE_DIR = File.join(TEST_DIR, 'fixtures')
RUBY_TEST_APP = File.join(TEST_DIR, 'ruby_test_app')

ROOT_DIR = File.expand_path('..', __dir__)
TEMPLATE_DIR = File.join(ROOT_DIR, 'lib', 'vite_rb', 'templates')

