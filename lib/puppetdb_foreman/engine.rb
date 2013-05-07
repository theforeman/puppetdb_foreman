module PuppetdbForeman
  class Engine < ::Rails::Engine

    config.to_prepare do
      Host::Managed.send :include, PuppetdbForeman::HostExtensions
    end

  end
end
