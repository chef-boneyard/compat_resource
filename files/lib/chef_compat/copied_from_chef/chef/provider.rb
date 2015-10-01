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
class Chef
  class Provider
    require 'chef/mixin/why_run'
    require 'chef/mixin/shell_out'
    require 'chef/mixin/provides'
    def self.include_resource_dsl(include_resource_dsl)
      @include_resource_dsl = include_resource_dsl
    end
    def self.use_inline_resources
      extend InlineResources::ClassMethods
      include InlineResources
    end
    module InlineResources

      # Our run context is a child of the main run context; that gives us a
      # whole new resource collection and notification set.
      def initialize(resource, run_context)
        super(resource, run_context.create_child)
      end

      # Class methods for InlineResources. Overrides the `action` DSL method
      # with one that enables inline resource convergence.
      #
      # @api private
      module ClassMethods
        # Defines an action method on the provider, running the block to
        # compile the resources, converging them, and then checking if any
        # were updated (and updating new-resource if so)
        def action(name, &block)
          # We first try to create the method using "def method_name", which is
          # preferred because it actually shows up in stack traces. If that
          # fails, we try define_method.
          begin
            class_eval <<-EOM, __FILE__, __LINE__+1
              def action_#{name}
                return_value = compile_action_#{name}
                Chef::Runner.new(run_context).converge
                return_value
              ensure
                if run_context.resource_collection.any? {|r| r.updated? }
                  new_resource.updated_by_last_action(true)
                end
              end
            EOM
          rescue SyntaxError
            define_method("action_#{name}") do
              begin
                return_value = send("compile_action_#{name}")
                Chef::Runner.new(run_context).converge
                return_value
              ensure
                if run_context.resource_collection.any? {|r| r.updated? }
                  new_resource.updated_by_last_action(true)
                end
              end
            end
          end
          # We put the action in its own method so that super() works.
          define_method("compile_action_#{name}", &block)
        end
      end

      require 'chef_compat/copied_from_chef/chef/dsl/recipe'
      include Chef::DSL::Recipe::FullDSL
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
