# compat_resource cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/compat_resource.svg?branch=master)](https://travis-ci.org/chef-cookbooks/compat_resource) [![Cookbook Version](https://img.shields.io/cookbook/v/compat_resource.svg)](https://supermarket.chef.io/cookbooks/compat_resource)

This cookbook backports functionality introduced in the latest chef-client releases to any chef-client from 12.1 onwards. This includes [Custom Resource](https://docs.chef.io/custom_resources.html) functionality, notification improvements, as well as new resources added to core chef. It allows for the usage of these new resources in cookbooks without requiring the very latest Chef client release.

## Backported functionality

- [Custom Resources](https://docs.chef.io/custom_resources.html)
- [apt_repository](https://docs.chef.io/resource_apt_repository.html)
- [apt_update](https://docs.chef.io/resource_apt_update.html)
- [systemd_unit](https://docs.chef.io/resource_systemd_unit.html)
- [yum_repository](https://docs.chef.io/resource_yum_repository.html)
- [:before notifications](https://docs.chef.io/resources.html#timers)

## Requirements

### Platforms

- All platforms supported by Chef

### Chef

- Chef 12.1+

### Cookbooks

- none

## Discouragement Policy

This repo is not necessarily deprecated, but its use is being discouraged.  Based on the policy in [RFC-092](https://github.com/chef/chef-rfc/blob/master/rfc092-dependency-update-cadence.md#cookbook-and-ecosystem-tooling-support) we now only support the prior 6 months of chef-client releases in current community cookbooks.  So as of Jul 2017 (for example) we only
support back to chef-client 12.18.31.  Users are expected to track current versions of Chef 12/13 for current community cookbook support and within a 6 month window to migrate to
new versions of chef-client.  As a result this cookbook is no longer viewed as being particularly necessary (and was always somewhat problematic).

## Usage

To use this cookbook, put `depends 'compat_resource'` in the metadata.rb of your cookbook. Once this is done, you can use all the new custom resource features to define resources. It Just Works.

## Custom Resources?

Curious about how to use custom resources? See the [Chef custom resource docs](https://docs.chef.io/custom_resources.html).

## License & Authors

- Author:: Lamont Granquist ([lamont@chef.io](mailto:lamont@chef.io))
- Author:: John Keiser ([jkeiser@chef.io](mailto:jkeiser@chef.io))

```text
Copyright:: 2015-2016 Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
