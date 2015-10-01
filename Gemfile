source 'https://rubygems.org'
gemspec
gem 'stove', '3.2.5'
if ENV['GEMFILE_MOD']
  instance_eval(ENV['GEMFILE_MOD'])
else
  gem 'chef', github: 'chef/chef'#, branch: '12.4.3'
end
