source 'https://rubygems.org'
gem 'stove'
gem 'rack', '< 2.0' # 2.0 requires Ruby 2.2+
gem 'rspec'
gem 'rake'
gem 'tomlrb'
gem 'test-kitchen'
gem 'berkshelf'
gem 'kitchen-dokken'
gem 'kitchen-inspec'

if ENV['GEMFILE_MOD']
  instance_eval(ENV['GEMFILE_MOD'])
else
  gem 'chef'
end
