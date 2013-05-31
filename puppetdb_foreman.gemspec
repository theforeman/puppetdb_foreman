require 'rake'
Gem::Specification.new do |s|
  s.name        = 'puppetdb_foreman'
  s.version     = '0.0.4'
  s.date        = '2013-03-19'
  s.summary     = ""
  s.description = ""
  s.authors     = ["Daniel Lobato Garcia"]
  s.email       = 'elobatocs@gmail.com'
  s.files       = FileList['app/**/**'].to_a + FileList['lib/**/**'].to_a
  s.homepage    = 'http://www.github.com/cernops/puppetdb_foreman'
end
