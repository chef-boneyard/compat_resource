require 'chef_compat/copied_from_chef'
module ChefCompat
module CopiedFromChef
class Chef < (defined?(::Chef) ? ::Chef : Object)
end
require 'chef_compat/copied_from_chef/chef/resource'
end
end
