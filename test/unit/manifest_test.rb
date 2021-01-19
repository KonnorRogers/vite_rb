# frozen_string_literal: true

require 'test_helper'
require 'json'

MANIFEST_FILE = File.join(FIXTURE_DIR, 'manifest.json')
MANIFEST_DATA = JSON.parse(File.read(MANIFEST_FILE), symbolize_names: true)

class ManifestTest < Minitest::Test
  def setup
    ViteRb.manifest = ViteRb::Manifest.new(MANIFEST_FILE)
  end

  def teardown
    ViteRb.manifest = nil
  end

  def test_parse_manifest_without_error
    assert_equal ViteRb.manifest.hash, MANIFEST_DATA
  end

  def test_finds_all_entrypoint_files
    js = ViteRb.manifest.find_entrypoint(:application, :js)
    js_map = ViteRb.manifest.find_entrypoint(:application, :"js.map")
    css = ViteRb.manifest.find_entrypoint(:application, :css)
    css_map = ViteRb.manifest.find_entrypoint(:application, :"css.map")

    assert_equal js, '/entrypoints/application-9856bc23.js'
    assert_equal js_map, '/entrypoints/application-9856bc23.js.map'
    assert_equal css, '/css/application-4ceb08db.css'
    assert_equal css_map, '/css/application-4ceb08db.css.map'
  end

  def test_find_file
    app = ViteRb.manifest.find_file('entrypoints/application.js')
    assert_equal app, '/entrypoints/application-9856bc23.js'

    non_existant = ViteRb.manifest.find_file('does-not-exist')
    assert_nil non_existant
  end
end
