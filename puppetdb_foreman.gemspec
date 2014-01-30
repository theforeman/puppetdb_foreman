require 'rake'
Gem::Specification.new do |s|
  s.name        = 'puppetdb_foreman'
  s.version     = '0.0.5'
  s.date        = '2014-01-30'
  s.summary     = 'This is a foreman plugin to interact with puppetdb through callbacks.'
  s.description = 'At the moment it basically disables hosts on puppetdb after they are deleted in Foreman. Follow https://github.com/cernops/puppetdb_foreman and raise an issue/submit a pull request if you need extra functionality'
  s.authors     = ["Daniel Lobato Garcia"]
  s.email       = 'elobatocs@gmail.com'
  s.files       = FileList['app/**/**'].to_a + FileList['lib/**/**'].to_a
  s.homepage    = 'http://www.github.com/cernops/puppetdb_foreman'
end
