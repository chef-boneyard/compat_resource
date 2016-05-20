provides :resource
resource_name :resource

action :create do
  log "stuff" do
    only_if { true }
  end
end
