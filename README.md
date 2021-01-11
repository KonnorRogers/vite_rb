# Vite

## WORK IN PROGRESS

If you would like to help support the future of this project,
please consider sponsoring me so I can keep a regular stream
of updates and fixes to this project.

https://github.com/sponsors/ParamagicDev

Please note, that this project is still in it's infancy. Feel free to
file bug reports, issues, and feature requests.

[![Gem Version](https://badge.fury.io/rb/vite_rb.svg)](https://badge.fury.io/rb/vite_rb)

<!-- [![Maintainability](https://api.codeclimate.com/v1/badges/b88ac1a56d868d4f23d5/maintainability)](https://codeclimate.com/github/ParamagicDev/vite_rb/maintainability) -->

This gem integrates the [Vite](https://vitejs.dev/) JS module bundler into
your Rails / Ruby application. It is inspired by gems such as
[breakfast](https://github.com/devlocker/breakfast) /
[webpacker](https://github.com/rails/webpacker) and this project started
as a fork of
[Vite](https://github.com/ParamagicDev/vite_rb).

This is not meant to be a 1:1 replacement of Webpacker. ViteRb is
actually just a wrapper around Vite using Rake / Thor and as a result can
be used with any Rack based framework. Vite comes with first class
support for Rails including Generators and autoloaded helpers.

## How is Vite different?

Vite is unbundled during development to eliminate compilation
times. Asset requests are cached with 304 headers. Bundling is saved for the final build process due to waterfall
network requests that still cause some issues in production and can
cause significant slowdown.

Vite uses the native ESM module spec. ESM Modules are fast,
lightweight, and natively supported by all newer browsers ("evergreen browsers")
For more reading on ESM modules, check out this link:

[https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vite_rb', git: "https://github.com/ParamagicDev/vite_rb"
```

### With Rails

```bash
rails vite:init
```

Which will install your yarn packages, create an initializer file, add config files, and create an `app/vite` directory similar to Webpacker.

#### Tasks

```bash
rails vite:dev # starts a dev server
rails vite:build # builds for production (is hooked onto
precompile)
rails assets:precompile # will build vite and the asset pipeline
```

#### Existing Rails app

When working with a new Rails app, it is important to switch any webpack
`require` statements to ESM-based `import`. For example, consider the
following javascript file:

```diff
// app/javascript/packs/application.js

- // Webpack
- require("@rails/ujs").start()
- require("turbolinks").start()
- require("@rails/activestorage").start()
- require("channels")
-
+ // app/vite/entrypoints/applications.js
+ import "@rails/ujs" // Autostarts
+ import Turbolinks from "turbolinks"
+ import ActiveStorage from "@rails/activestorage"
+ import "../channels"
+
+ Turbolinks.start()
+ ActiveStorage.start()
```

You may notice a `require.context` statement in your javascript to load
`channels`. This runs via Node and is not browser compatible. Vite comes
with a glob import syntax, you can read about it here: @TODO

```diff
// app/javascript/channels/index.js

// Load all the channels within this directory and all subdirectories.
// Channel files must be named *_channel.js.

- const channels = require.context('.', true, /_channel\.js$/)
- channels.keys().forEach(channels)
// @TODO
```

## File Structure

Vite makes some assumptions about your file paths to provide
helper methods.

```bash
tree -L 2 app/vite

app/vite/
├── assets/
│   └── picture.png
├── channels/
│   ├── consumer.js
│   └── index.js
├── entrypoints/
│   └── application.js
├── javascript/
│   └── index.js
└── stylesheets/
    └── index.css
```

Which upon build will output to look like this:

```bash
tree -L 1 public/Vites

public/vite/
├── assets/
├── channels/
├── entrypoints/
├── javascript/
├── css/
```

## Helpers

### Generic Helper

`<%= vite_path %>` will return the value of
`Vite.config.output_dir`

### Assets

Assets can be accessed via `<%= vite_asset_path("name", **options) %>` and accepts all
the same params as [#asset_path](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetUrlHelper.html#method-i-asset_path)

### Channels

Channels have no special helper.

### Packs

Packs can be accessed via:

`<%= javascript_vite_tag %>` and works the same as
[`#javascript_include_tag`](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-javascript_include_tag)

`packs` are your "entrypoints" and where files get bundled to, very
similar to Webpacker.

### Javascript

Javascript files have no special helper.

### Stylesheets

Stylesheets can be accessed via:

`<%= stylesheet_vite_tag %>` and works just like
[`#stylesheet_link_tag`](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-stylesheet_link_tag).
I recommend importing your css in your `packs` file if you plan on
changing it to support HMR.

### HMR

To enable HMR for your vite assets, put the following in the `<head>` of
your document:

`<%= vite_hmr_tag %>`

## Configuration

After running generator, the configuration file can be found in
`config/initializers/vite.rb`

In addition, all related `vite.config.js`, and
`postcss.config.js` can all be found in the `config/vite`
directory.

## Production

ViteRb hooks up to the `rails assets:precompile` and `rails
assets:clobber`, so no special setup is required.

You can start vite_rb's compilation process manually by running

```bash
rails vite:compile

# OR

rails vite:build
```


## Examples

Examples can be found in the [/examples](/examples) directory.

## Converting from Webpack to Snowpack

- `require.context()` is not currently supported

Instead, use the glob syntax from [Vite](https://vitejs.dev)

## Issues

Not all packages may be compatible with Vite. Please check
[skypack.dev](https://skypack.dev) for ESM-compatible packages.

## Changelog

See [CHANGELOG.md](https://github.com/ParamagicDev/vite_rb/blob/master/CHANGELOG.md)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ParamagicDev/vite_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Roadmap

- [ ] Add default file structure with init

- [x] Support require.context (Glob importing supported by Vite)

- [ ] Reading from production manifest

- [ ] Parity with Webpacker helper methods

- [ ] Add documentation / installation on Stimulus

- [ ] Create an npm package to read a default config from and pin Vite versions

- [ ] Add in End-to-end testing to confirm everything works as intended.

- [ ] Make the config environment from NPM in Typescript so users can import types for good completion.
