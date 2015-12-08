name 'compat_resource'
maintainer 'John Keiser'
maintainer_email 'jkeiser@chef.io'
license 'Apache 2.0'
description 'Chef 12.5 Resources, For Chef 12.1-12.4'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
require_relative 'files/lib/chef_compat/version'
version ChefCompat::VERSION
maintainer 'John Keiser'
maintainer_email 'jkeiser@chef.io'

chef_version '>= 12.0' if respond_to?(:chef_version)
source_url 'https://github.com/chef-cookbooks/compat_resource' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/compat_resource/issues' if respond_to?(:issues_url)
