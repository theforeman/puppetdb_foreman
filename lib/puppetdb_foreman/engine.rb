# frozen_string_literal: true

module PuppetdbForeman
  class Engine < ::Rails::Engine
    engine_name 'puppetdb_foreman'

    initializer 'puppetdb_foreman.load_app_instance_data' do |app|
      PuppetdbForeman::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'puppetdb_foreman.register_plugin', before: :finisher_hook do |_app|
      Foreman::Plugin.register :puppetdb_foreman do
        requires_foreman '>= 3.1'

        apipie_documented_controllers ["#{PuppetdbForeman::Engine.root}/app/controllers/api/v2/*.rb"]

        settings do
          category :puppetdb, N_('PuppetDB') do
            setting :puppetdb_enabled,
              type: :boolean,
              default: false,
              description: _("Integration with PuppetDB, enabled will deactivate a host in PuppetDB when it's deleted in Foreman")  # rubocop:disable Layout/LineLength

            setting :puppetdb_address,
              type: :string,
              default: 'https://puppetdb:8081/pdb/cmd/v1',
              description: _('Foreman will send PuppetDB requests to this address')

            setting :puppetdb_ssl_ca_file,
              type: :string,
              default: SETTINGS[:ssl_ca_file],
              description: _('Foreman will send PuppetDB requests with this CA file')

            setting :puppetdb_ssl_certificate,
              type: :string,
              default: SETTINGS[:ssl_certificate],
              description: _('Foreman will send PuppetDB requests with this certificate file')

            setting :puppetdb_ssl_private_key,
              type: :string,
              default: SETTINGS[:ssl_priv_key],
              description: _('Foreman will send PuppetDB requests with this key file')

            setting :puppetdb_api_version,
              type: :integer,
              default: 4,
              full_name: N_('PuppetDB API Version'),
              description: _('Foreman will use this PuppetDB API version'),
              collection: proc { ::Puppetdb::API_VERSIONS }
          end
        end

        security_block :puppetdb_foreman do
          permission :view_puppetdb_nodes, 'puppetdb_foreman/nodes': %i[index show],
                                           'api/v2/puppetdb_nodes': %i[index unknown]

          permission :destroy_puppetdb_nodes, 'puppetdb_foreman/nodes': [:destroy],
                                              'api/v2/puppetdb_nodes': [:destroy]

          permission :import_puppetdb_nodes, 'puppetdb_foreman/nodes': [:import],
                                             'api/v2/puppetdb_nodes': [:import]
        end

        role 'PuppetDB Node Viewer', [:view_puppetdb_nodes]
        role 'PuppetDB Node Manager', %i[view_puppetdb_nodes destroy_puppetdb_nodes import_puppetdb_nodes]

        menu :top_menu, :nodes, caption: N_('PuppetDB Nodes'),
                                url_hash: { controller: 'puppetdb_foreman/nodes', action: 'index' },
                                parent: :monitor_menu,
                                after: :puppetdb
      end
    end

    config.to_prepare do
      Host::Managed.include PuppetdbForeman::HostExtensions
      HostsHelper.include PuppetdbForeman::HostsHelperExtensions
    rescue StandardError => e
      Rails.logger.warn "PuppetdbForeman: skipping engine hook (#{e})"
    end
  end
end
