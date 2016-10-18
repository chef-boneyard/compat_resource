source 'https://rubygems.org'

gem 'stove'
gem 'rspec'
gem 'rake'
gem 'tomlrb'
gem 'test-kitchen'
gem 'kitchen-dokken'
# gem pinning sadness due to ruby < 2.2.0
gem 'kitchen-inspec', '< 0.15.0'
gem 'berkshelf', '< 5.0'
gem 'buff-extensions', '< 2.0'
gem 'rack', '< 2.0'

if ENV['GEMFILE_MOD']
  instance_eval(ENV['GEMFILE_MOD'])
else
  gem 'chef'
end
