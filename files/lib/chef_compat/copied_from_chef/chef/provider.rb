require 'chef_compat/copied_from_chef'
module ChefCompat
module CopiedFromChef
require 'chef/mixin/from_file'
require 'chef/mixin/convert_to_class_name'
require 'chef/mixin/enforce_ownership_and_permissions'
require 'chef/mixin/why_run'
require 'chef/mixin/shell_out'
require 'chef/mixin/powershell_out'
require 'chef/mixin/provides'
require 'chef/platform/service_helpers'
require 'chef/node_map'
require 'forwardable'
class Chef < (defined?(::Chef) ? ::Chef : Object)
  class Provider < (defined?(::Chef::Provider) ? ::Chef::Provider : Object)
    require 'chef/mixin/why_run'
    require 'chef/mixin/shell_out'
    require 'chef/mixin/provides'
    def self.include_resource_dsl(include_resource_dsl)
      @include_resource_dsl = include_resource_dsl
    end
    module InlineResources
      module ClassMethods
      end
      require 'chef_compat/copied_from_chef/chef/dsl/recipe'
    end
    protected
    module DeprecatedLWRPClass
      private
    end
  end
end
require 'chef/chef_class'
require 'chef/mixin/why_run'
require 'chef/resource_collection'
require 'chef/runner'
end
end
