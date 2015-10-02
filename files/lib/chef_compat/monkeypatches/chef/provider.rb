require 'chef/provider'
require 'chef/provider/lwrp_base'

class Chef::Provider
  if !defined?(InlineResources)
    InlineResources = Chef::Provider::LWRPBase::InlineResources
  end
  module InlineResources
    require 'chef/dsl/recipe'
    require 'chef/dsl/platform_introspection'
    require 'chef/dsl/data_query'
    require 'chef/dsl/include_recipe'
    include Chef::DSL::Recipe
    include Chef::DSL::PlatformIntrospection
    include Chef::DSL::DataQuery
    include Chef::DSL::IncludeRecipe
  end
end
