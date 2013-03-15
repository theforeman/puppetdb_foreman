module PuppetdbPlugin
  require 'puppetdb_plugin/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
end
