# frozen_string_literal: true

require 'vite_rb/generator'

namespace :vite do
  desc 'initializes vite'
  task :init do
    ViteRb::Generator.init
  end

  desc 'Compiles assets using snowpack bundler'
  task :build do
    ViteRb::Runner.build
  end

  desc 'Compiles assets using snowpack bundler'
  task compile: :build

  desc 'Run a snowpack dev server'
  task :dev do
    ViteRb::Runner.dev
  end
end
