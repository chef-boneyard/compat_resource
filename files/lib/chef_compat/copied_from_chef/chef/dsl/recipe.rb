require 'chef_compat/copied_from_chef'
class Chef
module ::ChefCompat
module CopiedFromChef
require 'chef_compat/copied_from_chef/chef/dsl/declare_resource'
class Chef < (defined?(::Chef) ? ::Chef : Object)
  module DSL
    if defined?(::Chef::DSL)
      include ::Chef::DSL
      @delegates_to = ::Chef::DSL
      require 'chef_compat/delegating_class'
      extend DelegatingClass
    end
    module Recipe
      if defined?(::Chef::DSL::Recipe)
        include ::Chef::DSL::Recipe
        @delegates_to = ::Chef::DSL::Recipe
        require 'chef_compat/delegating_class'
        extend DelegatingClass
      end
      include Chef::DSL::DeclareResource
      module FullDSL
        if defined?(::Chef::DSL::Recipe::FullDSL)
          include ::Chef::DSL::Recipe::FullDSL
          @delegates_to = ::Chef::DSL::Recipe::FullDSL
          require 'chef_compat/delegating_class'
          extend DelegatingClass
        end
        include Chef::DSL::Recipe
      end
    end
  end
end
require 'chef_compat/copied_from_chef/chef/resource'
end
end
end
