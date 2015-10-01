require 'tempfile'

describe "chef-compat cookbook" do
  let(:chef_repo_path) { File.expand_path('../data', __FILE__) }
  let(:chef_compat_cookbook_path) { File.join(chef_repo_path, 'cookbooks/chef-compat') }
  before { File.symlink(File.expand_path('../../..', __FILE__), chef_compat_cookbook_path) }
  after { File.unlink(chef_compat_cookbook_path) if File.exist?(chef_compat_cookbook_path) }

  it "when chef-client runs the test recipe, it succeeds" do
    expect(system "bundle exec chef-client -c #{File.join(chef_repo_path, 'config.rb')} -o test").to eq(true)
  end
end
