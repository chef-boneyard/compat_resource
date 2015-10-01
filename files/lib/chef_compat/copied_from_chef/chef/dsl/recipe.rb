require 'chef_compat/copied_from_chef'
module ChefCompat
module CopiedFromChef
require 'chef/mixin/convert_to_class_name'
require 'chef/exceptions'
require 'chef/mixin/shell_out'
require 'chef/mixin/powershell_out'
require 'chef/dsl/resources'
require 'chef/dsl/definitions'
class Chef < ::Chef::Chef
  module DSL
    module Recipe
      module FullDSL
        require 'chef/dsl/data_query'
        require 'chef/dsl/platform_introspection'
        require 'chef/dsl/include_recipe'
        require 'chef/dsl/registry_helper'
        require 'chef/dsl/reboot_pending'
        require 'chef/dsl/audit'
        require 'chef/dsl/powershell'
        include Chef::DSL::DataQuery
        include Chef::DSL::PlatformIntrospection
        include Chef::DSL::IncludeRecipe
        include Chef::DSL::Recipe
        include Chef::DSL::RegistryHelper
        include Chef::DSL::RebootPending
        include Chef::DSL::Audit
        include Chef::DSL::Powershell
      end
    end
  end
end
require 'chef/resource_builder'
require 'chef_compat/copied_from_chef/chef/resource'
require 'chef/mixin/recipe_definition_dsl_core'
end
end
