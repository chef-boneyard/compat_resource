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
    include Chef::Mixin::WhyRun
    include Chef::Mixin::ShellOut
    include Chef::Mixin::PowershellOut
    extend Chef::Mixin::Provides
    def initialize(new_resource, run_context)
      @new_resource = new_resource
      @action = action
      @current_resource = nil
      @run_context = run_context
      @converge_actions = nil

      @recipe_name = nil
      @cookbook_name = nil
      self.class.include_resource_dsl_module(new_resource)
    end
    def self.include_resource_dsl(include_resource_dsl)
      @include_resource_dsl = include_resource_dsl
    end
    def self.include_resource_dsl_module(resource)
      if @include_resource_dsl && !defined?(@included_resource_dsl_module)
        provider_class = self
        @included_resource_dsl_module = Module.new do
          extend Forwardable
          define_singleton_method(:to_s) { "#{resource_class} forwarder module" }
          define_singleton_method(:inspect) { to_s }
          # Add a delegator for each explicit property that will get the *current* value
          # of the property by default instead of the *actual* value.
          resource.class.properties.each do |name, property|
            class_eval(<<-EOM, __FILE__, __LINE__)
              def #{name}(*args, &block)
                # If no arguments were passed, we process "get" by defaulting
                # the value to current_resource, not new_resource. This helps
                # avoid issues where resources accidentally overwrite perfectly
                # valid stuff with default values.
                if args.empty? && !block
                  if !new_resource.property_is_set?(__method__) && current_resource
                    return current_resource.public_send(__method__)
                  end
                end
                new_resource.public_send(__method__, *args, &block)
              end
            EOM
          end
          dsl_methods =
             resource.class.public_instance_methods +
             resource.class.protected_instance_methods -
             provider_class.instance_methods -
             resource.class.properties.keys
          def_delegators(:new_resource, *dsl_methods)
        end
        include @included_resource_dsl_module
      end
    end
    def self.use_inline_resources
      extend InlineResources::ClassMethods
      include InlineResources
    end
    protected
    extend DeprecatedLWRPClass
  end
end
require 'chef/chef_class'
require 'chef/mixin/why_run'
require 'chef/resource_collection'
require 'chef/runner'
end
end
