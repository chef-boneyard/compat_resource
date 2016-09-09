filename = "/tmp/lksjdfkASDFASdlkfl.out"

file filename do
  action :delete
end

cookbook_file filename do
  source "file"
end

log "it worked" do
  subscribes :write, "file[filename]", :immediately
  action :nothing
end
