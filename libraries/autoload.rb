unless Gem::Requirement.new(">= 12.0").satisfied_by?(Gem::Version.new(Chef::VERSION))
  raise "The compat_resources cookbook does not support chef versions older than Chef 12.0.0"
end

begin
  compat_resource_gem = Gem::Specification.find_by_name("compat_resource")
rescue Gem::LoadError
end

if compat_resource_gem
  # The gem is installed.
  require 'chef_compat'
  # Make sure the version installed is more recent than the cookbook so there's no confusion.
  version_rb = IO.read(File.expand_path("../../files/lib/chef_compat/version.rb", __FILE__))
  raise "Version file not in correct format" unless version_rb =~ /VERSION\s*=\s*'([^']+)'/
  version = $1
  if Gem::Version.new(version) > Gem::Version.new(ChefCompat::VERSION)
    raise "Installed compat_resource gem #{ChefCompat::VERSION} is *older* than the compat_resource cookbook. Please install a more recent version."
  end
  Chef::Log.info("Using compat_resource gem version #{ChefCompat::VERSION} installed on system instead of compat_resource cookbook (which is version #{version}).")
else

  # The cookbook is the only copy; load the cookbook.
  $:.unshift File.expand_path("../../files/lib", __FILE__)
  begin
    require 'chef_compat'
  rescue LoadError
    raise "Could not find my own library file, this is most likely due to no_lazy_load being set to false, please see https://github.com/chef-cookbooks/compat_resource/issues/10"
  end
end
