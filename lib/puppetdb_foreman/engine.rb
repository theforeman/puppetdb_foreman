module PuppetdbForeman
  class Engine < ::Rails::Engine
    engine_name 'puppetdb_foreman'

    initializer 'puppetdb_foreman.load_default_settings', :before => :load_config_initializers do |_app|
      require_dependency File.expand_path('../../../app/models/setting/puppetdb.rb', __FILE__) if begin
                                                                                                     Setting.table_exists?
                                                                                                   rescue
                                                                                                     (false)
                                                                                                   end
    end

    initializer 'puppetdb_foreman.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :puppetdb_foreman do
        requires_foreman '>= 1.11'
        security_block :puppetdb_foreman do
          permission :view_puppetdb_dashboard, :'puppetdb_foreman/puppetdb' => [:index]
        end
        role 'PuppetDB Dashboard', [:view_puppetdb_dashboard]
        menu :top_menu, :puppetdb, :caption => N_('PuppetDB Dashboard'),
                                   :url_hash => { :controller => 'puppetdb_foreman/puppetdb', :action => 'index', :puppetdb => 'puppetdb' },
                                   :parent => :monitor_menu,
                                   :last => true
      end
    end

    config.to_prepare do
      Host::Managed.send :include, PuppetdbForeman::HostExtensions
    end
  end
end
