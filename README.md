# compat_resource cookbook

This cookbook brings the custom resource syntax from Chef 12.5 down to earlier
versions (12.0-12.5).

This cookbook is early days. It has some [travis tests](https://travis-ci.org/jkeiser/compat_resource) verifying the test matrix of rubies and chef versions.

## Usage

To use this cookbook, put `depends 'compat_resource'` in the metadata.rb of your cookbook. Once this is done, you can use all the new custom resource features to define resources. It Just Works.

For example, if you create resources/myresource.rb, myresource can use `property`, `load_current_value` and `action` (no need to create a provider). If you want to create Resource classes directly, extend from `ChefCompat::Resource` instead of `Chef::Resource`. Properties, current value loading, converge_if_changed, and resource_name will all function the same across versions.

## Custom Resources?

Curious about how to use custom resources? Here are the 12.5 docs:

- Docs: https://docs.chef.io/custom_resources.html
- Slides: https://docs.chef.io/decks/custom_resources.html

## Contributing

Try it! [File issues](https://github.com/jkeiser/compat_resource/issues) or fork and submit a pull request at https://github.com/jkeiser/compat_resource if you see issues.
