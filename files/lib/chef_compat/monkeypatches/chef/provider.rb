require 'chef/provider'

class Chef::Provider
  if !defined?(InlineResources)
    InlineResources = Chef::Provider::LWRPBase::InlineResources
  end
end
