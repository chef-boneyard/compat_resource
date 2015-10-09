# compat_resource cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/compat_resource.svg?branch=master)](https://travis-ci.org/chef-cookbooks/compat_resource)
[![Cookbook Version](https://img.shields.io/cookbook/v/compat_resource.svg)](https://supermarket.chef.io/cookbooks/compat_resource)


This cookbook brings the custom resource syntax from Chef 12.5 to earlier Chef 12.X releases.


Requirements
------------
#### Platforms
- All platforms supported by Chef

#### Chef
- Chef 12.0+

#### Cookbooks
- none


## Usage

To use this cookbook, put `depends 'compat_resource'` in the metadata.rb of your cookbook. Once this is done, you can use all the new custom resource features to define resources. It Just Works.

For example, if you create resources/myresource.rb, myresource can use `property`, `load_current_value` and `action` (no need to create a provider). If you want to create Resource classes directly, extend from `ChefCompat::Resource` instead of `Chef::Resource`. Properties, current value loading, converge_if_changed, and resource_name will all function the same across versions.

## Custom Resources?

Curious about how to use custom resources? Here are the 12.5 docs:

- Docs: https://docs.chef.io/custom_resources.html
- Slides: https://docs.chef.io/decks/custom_resources.html


##License & Authors

**Author:** John Keiser (<jkeiser@chef.io>)

**Copyright:** 2015, Chef Software, Inc.
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.