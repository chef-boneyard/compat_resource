# If the gem is already activated rather than the cookbook, then we fail if our version is DIFFERENT.
# The user said they wanted this cookbook version, they need to have this cookbook version.
# NOTE: if the gem is installed but on a different version, we simply don't care: the cookbook version wins.
if defined?(ChefCompat)
  version_rb = IO.read(File.expand_path("../../files/lib/chef_compat/version.rb", __FILE__))
  raise "Version file not in correct format" unless version_rb =~ /VERSION\s*=\s*'([^']+)'/
  cookbook_version = $1

  if ChefCompat::VERSION != cookbook_version
    raise "compat_resource gem version #{ChefCompat::VERSION} was loaded as a gem before compat_resource cookbook version #{cookbook_version} was loaded. To remedy this, either update the cookbook to the gem version, update the gem to the cookbook version, or uninstall / stop loading the gem so early."
  end
else
  # The gem is not already activated, so activate the cookbook.
  require_relative '../files/lib/chef_compat/gemspec'

  a = $:.dup
  ChefCompat::GEMSPEC.activate
  b = $:.dup
  puts "full_require_paths: #{ChefCompat::GEMSPEC.full_require_paths}"
  puts (b - a).inspect
  puts "Exists? #{File.exist?("#{(b - a)[0]}/chef_compat.rb")}"
  puts IO.read("#{(b - a)[0]}/chef_compat.rb")
  require 'chef_compat'
end
