unless Gem::Requirement.new(">= 12.0").satisfied_by?(Gem::Version.new(Chef::VERSION))
  raise "This resource is written with Chef 12.5 custom resources, and requires at least Chef 12.0 used with the compat_resource cookbook, it will not work with Chef 11.x clients, and those users must pin their cookbooks to older versions or upgrade."
end

# we no longer support loading with a gem
if Gem.loaded_specs["compat_resource"]
  raise "using compat_resource as a gem is deprecated;  please update your gems to cheffish >= 3.0.0 and chef-provisioning >= 1.9.1 to eliminate it"
end

# The gem is not already activated, so activate the cookbook.
require_relative '../files/lib/compat_resource/gemspec'
CompatResource::GEMSPEC.activate

require 'compat_resource'
