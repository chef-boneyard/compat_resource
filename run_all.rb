require 'yaml'
travis = YAML.load(IO.read('.travis.yml'))
env = Array(travis['env']) + travis['matrix']['include'].map { |x| Array(x['env']) }.flatten
env.each do |env|
  puts("bash -c \"export #{env}; bundle update && bundle exec rake spec\"")
  system("export #{env} && bundle update && bundle exec rake spec")
end
