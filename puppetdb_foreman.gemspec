require File.expand_path('../lib/puppetdb_foreman/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'puppetdb_foreman'
  s.version     = PuppetdbForeman::VERSION
  s.date        = Date.today.to_s
  s.license     = 'GPL-3.0'
  s.summary     = 'This is a Foreman plugin to interact with PuppetDB.'
  s.description = 'Disable hosts on PuppetDB after they are deleted or built in Foreman, and proxy the PuppetDB dashboard to Foreman. Follow https://github.com/theforeman/puppetdb_foreman and raise an issue/submit a pull request if you need extra functionality. You can also find some help in #theforeman IRC channel on Freenode.'
  s.authors     = ['Daniel Lobato Garcia']
  s.email       = 'elobatocs@gmail.com'
  s.files       = Dir['{app,db,config,lib}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files  = Dir['test/**/*']
  s.homepage    = 'http://www.github.com/theforeman/puppetdb_foreman'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop', '0.51.0'
  s.add_development_dependency 'webmock'
end
