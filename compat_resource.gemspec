$:.unshift File.expand_path('../files/lib', __FILE__)
project = File.basename(__FILE__)[0..-'.gemspec'.length-1]
require "chef_compat/version"

Gem::Specification.new do |s|
  s.name = project
  s.version = ChefCompat::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = 'Bring some new features of Chef 12.5 to previous 12.X releases'
  s.description = s.summary
  s.author = 'John Keiser'
  s.email = 'john@johnkeiser.com'
  s.homepage = 'http://chef.io'
  s.license = 'Apache 2.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'cheffish'
  s.add_development_dependency 'stove'

  s.bindir       = 'bin'
  s.executables  = []
  s.require_path = 'files/lib'
  s.files = %w(LICENSE README.md CHANGELOG.md Gemfile Rakefile) + Dir.glob('{files/lib,spec}/**/*', File::FNM_DOTMATCH).reject {|f| File.directory?(f)}
end
