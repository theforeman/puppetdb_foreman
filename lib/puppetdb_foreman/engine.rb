module PuppetdbForeman
  class Engine < ::Rails::Engine

    config.to_prepare do
      Host.send :include, PuppetdbForeman::HostExtensions
    end

  end
end
