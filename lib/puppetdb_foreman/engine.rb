module PuppetdbForeman
  class Engine < ::Rails::Engine

    config.to_prepare do
      if defined? Host::Managed
        # Foreman 1.2
        Host::Managed.send :include, PuppetdbForeman::HostExtensions
      else
        # Foreman < 1.2
        Host.send :include, PuppetdbForeman::HostExtensions
      end
    end

  end
end
