require 'chef_compat/copied_from_chef'
class Chef
module ::ChefCompat
module CopiedFromChef
require 'chef_compat/copied_from_chef/chef/mixin/params_validate'
require 'chef_compat/copied_from_chef/chef/resource/action_class'
class Chef < (defined?(::Chef) ? ::Chef : Object)
  class Resource < (defined?(::Chef::Resource) ? ::Chef::Resource : Object)
    def initialize(name, run_context=nil)
super if defined?(::Chef::Resource)
      name(name) unless name.nil?
      @run_context = run_context
      @noop = nil
      @before = nil
      @params = Hash.new
      @provider = nil
      @allowed_actions = self.class.allowed_actions.to_a
      @action = self.class.default_action
      @updated = false
      @updated_by_last_action = false
      @supports = {}
      @ignore_failure = false
      @retries = 0
      @retry_delay = 2
      @not_if = []
      @only_if = []
      @source_line = nil
      # We would like to raise an error when the user gives us a guard
      # interpreter and a ruby_block to the guard. In order to achieve this
      # we need to understand when the user overrides the default guard
      # interpreter. Therefore we store the default separately in a different
      # attribute.
      @guard_interpreter = nil
      @default_guard_interpreter = :default
      @elapsed_time = 0
      @sensitive = false
    end
    def self.properties(include_superclass=true)
      @properties ||= {}
      if include_superclass
        if superclass.respond_to?(:properties)
          superclass.properties.merge(@properties)
        else
          @properties.dup
        end
      else
        @properties
      end
    end
    def action(arg=nil)
      if arg
        arg = Array(arg).map(&:to_sym)
        arg.each do |action|
          validate(
            { action: action },
            { action: { kind_of: Symbol, equal_to: allowed_actions } }
          )
        end
        @action = arg
      else
        @action
      end
    end
    alias_method :action=, :action
    def state_for_resource_reporter
      state = {}
      state_properties = self.class.state_properties
      state_properties.each do |property|
        if property.identity? || property.is_set?(self)
          state[property.name] = send(property.name)
        end
      end
      state
    end
    alias_method :state, :state_for_resource_reporter
    def identity
      result = {}
      identity_properties = self.class.identity_properties
      identity_properties.each do |property|
        result[property.name] = send(property.name)
      end
      return result.values.first if identity_properties.size == 1
      result
    end
    include Chef::Mixin::ParamsValidate
    def self.property(name, type=NOT_PASSED, **options)
      name = name.to_sym

      options.each { |k,v| options[k.to_sym] = v if k.is_a?(String) }

      options[:instance_variable_name] = :"@#{name}" if !options.has_key?(:instance_variable_name)
      options.merge!(name: name, declared_in: self)

      if type == NOT_PASSED
        # If a type is not passed, the property derives from the
        # superclass property (if any)
        if properties.has_key?(name)
          property = properties[name].derive(**options)
        else
          property = property_type(**options)
        end

      # If a Property is specified, derive a new one from that.
      elsif type.is_a?(Property) || (type.is_a?(Class) && type <= Property)
        property = type.derive(**options)

      # If a primitive type was passed, combine it with "is"
      else
        if options[:is]
          options[:is] = ([ type ] + [ options[:is] ]).flatten(1)
        else
          options[:is] = type
        end
        property = property_type(**options)
      end

      local_properties = properties(false)
      local_properties[name] = property

      property.emit_dsl
    end
    def self.property_type(**options)
      Property.derive(**options)
    end
    property :name, String, coerce: proc { |v| v.is_a?(Array) ? v.join(', ') : v.to_s }, desired_state: false
    def property_is_set?(name)
      property = self.class.properties[name.to_sym]
      raise ArgumentError, "Property #{name} is not defined in class #{self}" if !property
      property.is_set?(self)
    end
    def reset_property(name)
      property = self.class.properties[name.to_sym]
      raise ArgumentError, "Property #{name} is not defined in class #{self}" if !property
      property.reset(self)
    end
    def self.lazy(&block)
      DelayedEvaluator.new(&block)
    end
    def self.state_properties(*names)
      if !names.empty?
        names = names.map { |name| name.to_sym }.uniq

        local_properties = properties(false)
        # Add new properties to the list.
        names.each do |name|
          property = properties[name]
          if !property
            self.property name, instance_variable_name: false, desired_state: true
          elsif !property.desired_state?
            self.property name, desired_state: true
          end
        end

        # If state_attrs *excludes* something which is currently desired state,
        # mark it as desired_state: false.
        local_properties.each do |name,property|
          if property.desired_state? && !names.include?(name)
            self.property name, desired_state: false
          end
        end
      end

      properties.values.select { |property| property.desired_state? }
    end
    def self.identity_properties(*names)
      if !names.empty?
        names = names.map { |name| name.to_sym }

        # Add or change properties that are not part of the identity.
        names.each do |name|
          property = properties[name]
          if !property
            self.property name, instance_variable_name: false, identity: true
          elsif !property.identity?
            self.property name, identity: true
          end
        end

        # If identity_properties *excludes* something which is currently part of
        # the identity, mark it as identity: false.
        properties.each do |name,property|
          if property.identity? && !names.include?(name)
            self.property name, identity: false
          end
        end
      end

      result = properties.values.select { |property| property.identity? }
      result = [ properties[:name] ] if result.empty?
      result
    end
    def self.identity_property(name=nil)
      result = identity_properties(*Array(name))
      if result.size > 1
        raise Chef::Exceptions::MultipleIdentityError, "identity_property cannot be called on an object with more than one identity property (#{result.map { |r| r.name }.join(", ")})."
      end
      result.first
    end
    attr_accessor :allowed_actions
    def allowed_actions(value=NOT_PASSED)
      if value != NOT_PASSED
        self.allowed_actions = value
      end
      @allowed_actions
    end
    def resource_name
      @resource_name || self.class.resource_name
    end
    def self.use_automatic_resource_name
      automatic_name = convert_to_snake_case(self.name.split('::')[-1])
      resource_name automatic_name
    end
    def self.allowed_actions(*actions)
      @allowed_actions ||=
        if superclass.respond_to?(:allowed_actions)
          superclass.allowed_actions.dup
        else
          [ :nothing ]
        end
      @allowed_actions |= actions.flatten
    end
    def self.allowed_actions=(value)
      @allowed_actions = value.uniq
    end
    def self.default_action(action_name=NOT_PASSED)
      unless action_name.equal?(NOT_PASSED)
        @default_action = Array(action_name).map(&:to_sym)
        self.allowed_actions |= @default_action
      end

      if @default_action
        @default_action
      elsif superclass.respond_to?(:default_action)
        superclass.default_action
      else
        [:nothing]
      end
    end
    def self.default_action=(action_name)
      default_action action_name
    end
    def self.action(action, &recipe_block)
      action = action.to_sym
      declare_action_class
      action_class.action(action, &recipe_block)
      self.allowed_actions += [ action ]
      default_action action if Array(default_action) == [:nothing]
    end
    def self.load_current_value(&load_block)
      define_method(:load_current_value!, &load_block)
    end
    def current_value_does_not_exist!
      raise Chef::Exceptions::CurrentValueDoesNotExist
    end
    def self.action_class
      @action_class ||
        # If the superclass needed one, then we need one as well.
        if superclass.respond_to?(:action_class) && superclass.action_class
          declare_action_class
        end
    end
    def self.declare_action_class
      return @action_class if @action_class

      if superclass.respond_to?(:action_class)
        base_provider = superclass.action_class
      end
      base_provider ||= Chef::Provider

      resource_class = self
      @action_class = Class.new(base_provider) do
        include ActionClass
        self.resource_class = resource_class
      end
    end
    FORBIDDEN_IVARS = [:@run_context, :@not_if, :@only_if, :@enclosing_provider]
    HIDDEN_IVARS = [:@allowed_actions, :@resource_name, :@source_line, :@run_context, :@name, :@not_if, :@only_if, :@elapsed_time, :@enclosing_provider]
    class << self
    end
    @@sorted_descendants = nil
    private
  end
end
end
end
end
