class Chef
  module DSL
  end
  module Mixin
  end
end

module ChefCompat
  module DelegatingClass
    def method_missing(name, *args, &block)
      @delegates_to.send(name, *args, &block)
    end
    def const_missing(name)
      @delegates_to.const_get(name)
    end
  end

  module CopiedFromChef
    class Chef < ::Chef
      module DSL
        extend DelegatingClass
        @delegates_to = ::Chef::DSL
      end
      module Mixin
        extend DelegatingClass
        @delegates_to = ::Chef::Mixin
      end
    end
  end
end

# Because resource does not include chef/provider, we have to do it here
require 'chef_compat/copied_from_chef/chef/provider'
