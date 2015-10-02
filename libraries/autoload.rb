# FIRST! Since this is both a gem and a cookbook, check whether the gem has already been loaded.
# If it has already been loaded, we have a conflict. Instruct the user to put compat_resource
# earlier in the run list.
if defined?(ChefCompat)
  Chef::Log.warn "ChefCompat already loaded as a gem! The gem will be used instead of the cookbook."
end

$:.unshift File.expand_path("../../files/lib", __FILE__)
require 'chef_compat'
