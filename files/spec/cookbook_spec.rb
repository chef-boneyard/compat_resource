require 'tmpdir'

describe "chef-compat cookbook" do
  let(:chef_repo_path) { Dir.mktmpdir }
  let(:cookbooks_path) { path = File.join(chef_repo_path, 'cookbooks'); Dir.mkdir(path); path }
  before do
    File.symlink(File.expand_path('../data/config.rb', __FILE__),
                 File.join(chef_repo_path, 'config.rb'))
    File.symlink(File.expand_path('../../..', __FILE__),
                 File.join(cookbooks_path, 'chef-compat'))
    File.symlink(File.expand_path('../data/cookbooks/test', __FILE__),
                 File.join(cookbooks_path, 'test'))
    File.symlink(File.expand_path('../data/cookbooks/future', __FILE__),
                 File.join(cookbooks_path, 'future'))
    File.symlink(File.expand_path('../data/cookbooks/normal', __FILE__),
                 File.join(cookbooks_path, 'normal'))
  end

  it "when chef-client runs the test recipe, it succeeds" do
    expect(system "bundle exec chef-client -c #{File.join(chef_repo_path, 'config.rb')} -o test").to eq(true)
  end
end
