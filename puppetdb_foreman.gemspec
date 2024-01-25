# frozen_string_literal: true

require File.expand_path('lib/puppetdb_foreman/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'puppetdb_foreman'
  s.version     = PuppetdbForeman::VERSION
  s.license     = 'GPL-3.0'
  s.summary     = 'This is a Foreman plugin to interact with PuppetDB.'

  s.description = <<-DESC
    Disable hosts on PuppetDB after they are deleted or built in Foreman.
    Follow https://github.com/theforeman/puppetdb_foreman and raise an
    issue/submit a pull request if you need extra functionality. You can also
    find some help via the Foreman support pages
    (https://theforeman.org/support.html).
  DESC

  s.authors     = ['Daniel Lobato Garcia']
  s.email       = 'elobatocs@gmail.com'
  s.files       = Dir['{app,db,config,lib}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files  = Dir['test/**/*']
  s.homepage    = 'http://www.github.com/theforeman/puppetdb_foreman'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'theforeman-rubocop', '~> 0.1.2'
  s.add_development_dependency 'webmock'
end
