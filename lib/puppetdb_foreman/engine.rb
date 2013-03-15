require 'hubot_notify'

module PuppetdbPlugin
  class Engine < ::Rails::Engine

    # Include extensions to models in this config.to_prepare block
    config.to_prepare do
      #Example: Include host extenstions
      Host.send :include, PuppetdbPlugin::Callbacks
    end

  end
end
