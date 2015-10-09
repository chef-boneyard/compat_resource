class Chef
  NOT_PASSED = Object.new if !defined?(NOT_PASSED)
  # Earlier versions of Chef didn't have this message
  module ChefCompatDeprecation
    def log_deprecation(message, location=nil)
      if superclass.respond_to?(:log_deprecation)
        if !location
          # Pick the first caller that is *not* part of the Chef or ChefCompat gem,
          # that's the thing the user wrote.
          chef_compat_gem_path = File.expand_path("../../..", __FILE__)
          chef_gem_path = File.expand_path("../..",::Chef::Resource.instance_method(:initialize).source_location[0])
          caller(0..10).each do |c|
            if !c.start_with?(chef_gem_path) && !c.start_with?(chef_compat_gem_path)
              location = c
              break
            end
          end
        end

        super
      else
        Chef::Log.warn(message)
      end
    end
  end

  class<<self
    prepend ChefCompatDeprecation
  end
end
