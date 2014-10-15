module PuppetdbForeman
  require 'puppetdb_foreman/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
end
