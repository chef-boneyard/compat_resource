require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'stove/rake_task'
require 'fileutils'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = FileList['files/spec/**/*_spec.rb']
end
Stove::RakeTask.new

task default: [ :update, :spec ]

CHEF_FILES = %w(chef/constants chef/delayed_evaluator chef/property
                chef/resource chef/resource/action_class chef/provider chef/dsl/recipe
                chef/mixin/params_validate)
SPEC_FILES = %w(unit/property_spec.rb unit/property/state_spec.rb unit/property/validation_spec.rb
                integration/recipes/resource_action_spec.rb
                integration/recipes/resource_converge_if_changed_spec.rb
                integration/recipes/resource_load_spec.rb)
KEEP_FUNCTIONS = {
  'chef/resource' => %w(
    initialize

    resource_name self.use_automatic_resource_name

    identity state state_for_resource_reporter property_is_set reset_property
    self.properties self.state_properties self.state_attr
    self.identity_properties self.identity_property self.identity_attrs
    self.property self.property_type
    self.lazy

    action allowed_actions self.allowed_actions self.default_action
    self.action self.declare_action_class self.action_class

    load_current_value current_value_does_not_exist!
    self.load_current_value

    Chef::Mixin::ParamsValidate
  ),
  'chef/dsl/recipe' => %w(
    FullDSL
  ),
  'chef/provider' => %w(
    self.include_resource_dsl
  )
}
# See chef_compat/resource for def. of resource_name and provider
# See chef_compat/monkeypatches/chef/resource for def. of current_value

task :update do
  # Copy files from chef to chef_compat/chef, with a few changes
  target_path = File.expand_path("../files/lib/chef_compat/copied_from_chef", __FILE__)
  chef_gem_path = Bundler.environment.specs['chef'].first.full_gem_path
  CHEF_FILES.each do |file|
    output = StringIO.new
    # Wrap the whole thing in a ChefCompat module
    output.puts "require 'chef_compat/copied_from_chef'"
    output.puts "module ChefCompat"
    output.puts "module CopiedFromChef"

    # Bring over the Chef file
    chef_contents = IO.read(File.join(chef_gem_path, 'lib', "#{file}.rb"))
    current_function = nil
    current_function_indent = nil
    chef_contents.lines.each do |line|
      # If this file only keeps certain functions, detect which function we are
      # in and only keep those. Also strip comments outside functions
      if KEEP_FUNCTIONS[file]
        if current_function
          if line =~ /^#{current_function_indent}end\b/
            was_keeper = KEEP_FUNCTIONS[file].include?(current_function)
            current_function = nil
            current_function_indent = nil
            next if !was_keeper
          end
        elsif line =~ /^(\s*)def\s+([A-Za-z0-9_.]+)/
          current_function = $2
          current_function_indent = $1
        elsif line =~ /^(\s*)module\s+([A-Za-z0-9_:]+)/ && KEEP_FUNCTIONS[file].include?($2)
          current_function = $2
          current_function_indent = $1
        elsif line =~ /^\s*#/ || line =~ /^\s*$/
          next
        elsif line =~ /^\s*(attr_reader|attr_writer|attr_accessor|property|alias)\s*:(\w+)/ && !KEEP_FUNCTIONS[file].include?($2)
          next
        elsif line =~ /^\s*(include|extend)\s*([A-Za-z0-9_:]+)/ && !KEEP_FUNCTIONS[file].include?($2)
          next
        end
        next if current_function && !KEEP_FUNCTIONS[file].include?(current_function)
      end

      # Modify requires to overridden files to bring in the local version
      if line =~ /^(\s*require\s*['"])(.+)(['"]\s*)$/
        if CHEF_FILES.include?($2)
          line = "#{$1}chef_compat/copied_from_chef/#{$2}#{$3}"
        end
      end
      # descend from the real version of the class
      if line =~ /^(\s*class\s+)(\w+)(\s*)$/
        if $2 == "Chef"
          new_class = "::#{$2}"
        else
          new_class = "::Chef::#{$2}"
        end
        line = "#{$1}#{$2} < (defined?(#{new_class}) ? #{new_class} : Object)#{$3}"
      end

      output.puts line
    end
    # Close the ChefCompat module declaration from the top
    output.puts "end"
    output.puts "end"

    # Write out the file in chef_compat
    target_file = File.join(target_path, "#{file}.rb")
    if !File.exist?(target_file) || IO.read(target_file) != output.string
      puts "Writing #{target_file} ..."
      FileUtils.mkdir_p(File.dirname(target_file))
      File.open(target_file, "w") { |f| f.write(output.string) }
    end
  end

  # SPEC_FILES.each do |file|
  #   target_path = File.expand_path("../files/spec/copied_from_chef", __FILE__)
  #   source_file = File.join(chef_gem_path, 'lib', "#{file}.rb")
  #   target_file = File.join(target_path, "#{file}")
  # end
end
