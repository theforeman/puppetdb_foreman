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
          permission :view_puppetdb_nodes, :'puppetdb_foreman/nodes' => [:index]
          permission :destroy_puppetdb_nodes, :'puppetdb_foreman/nodes' => [:destroy]
        end
        role 'PuppetDB Dashboard', [:view_puppetdb_dashboard]
        role 'PuppetDB Node Viewer', [:view_puppetdb_nodes]
        role 'PuppetDB Node Manager', [:view_puppetdb_nodes, :destroy_puppetdb_nodes]
        menu :top_menu, :puppetdb, :caption => N_('PuppetDB Dashboard'),
                                   :url_hash => { :controller => 'puppetdb_foreman/puppetdb', :action => 'index', :puppetdb => 'puppetdb' },
                                   :parent => :monitor_menu,
                                   :last => :true
        menu :top_menu, :nodes, :caption => N_('PuppetDB Nodes'),
                                :url_hash => { :controller => 'puppetdb_foreman/nodes', :action => 'index' },
                                :parent => :monitor_menu,
                                :after => :puppetdb
      end
    end

    config.to_prepare do
      begin
        Host::Managed.send :include, PuppetdbForeman::HostExtensions
      rescue => e
        Rails.logger.warn "PuppetdbForeman: skipping engine hook (#{e})"
      end
    end
  end
end
