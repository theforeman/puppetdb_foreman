require 'rake'
Gem::Specification.new do |s|
  s.name        = 'puppetdb_foreman'
  s.version     = '0.1.1'
  s.date        = '2014-10-11'
  s.license     = 'Apache-2.0'
  s.summary     = 'This is a Foreman plugin to interact with PuppetDB.'
  s.description = 'Disable hosts on PuppetDB after they are deleted or built in Foreman, and proxy the PuppetDB dashboard to Foreman. Follow https://github.com/theforeman/puppetdb_foreman and raise an issue/submit a pull request if you need extra functionality. You can also find some help in #theforeman IRC channel on Freenode.'
  s.authors     = ["Daniel Lobato Garcia"]
  s.email       = 'elobatocs@gmail.com'
  s.files       = FileList['app/**/**'].to_a + FileList['config/**/**'].to_a+ FileList['lib/**/**'].to_a
  s.homepage    = 'http://www.github.com/theforeman/puppetdb_foreman'
end
