# frozen_string_literal: true

require 'test_helper'
require 'json'

MANIFEST_FILE = File.join(FIXTURE_DIR, 'manifest.json')
MANIFEST_DATA = JSON.parse(File.read(MANIFEST_FILE))

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

  def test_find_bare_entry
    application = "application.js"
    file = ViteRb.manifest.find_file(application)
    manifest_file = MANIFEST_DATA[application]["file"]
    assert_equal file, manifest_file
  end

  def test_find_nested_file
    # nested files
    nested = "nested/nested_entrypoint.js"
    file = ViteRb.manifest.find_file(nested)
    manifest_file = MANIFEST_DATA[nested]["file"]

    assert_equal file, manifest_file
  end

  def test_no_file_found
    assert_nil ViteRb.manifest.find_file('does-not-exist')
  end
end
