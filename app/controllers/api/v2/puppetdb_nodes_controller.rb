# frozen_string_literal: true

module Api
  module V2
    class PuppetdbNodesController < V2::BaseController
      include Api::Version2
      before_action :find_node, only: %i[destroy import]

      layout 'api/v2/layouts/index_layout', only: %i[index unknown]

      api :GET, '/puppetdb_nodes/', N_('List all PuppetDB nodes')
      def index
        @nodes = Puppetdb.client.query_nodes
      end

      api :GET, '/puppetdb_nodes/unknown/', N_('List all PuppetDB nodes without a Host in Foreman')
      def unknown
        @foreman_hosts = Host.unscoped.pluck(:name)
        @puppetdb_hosts = Puppetdb.client.query_nodes
        @nodes = @puppetdb_hosts - @foreman_hosts
      end

      api :DELETE, '/puppetdb_nodes/:id/', N_('Deactivate a node in PuppetDB')
      param :id, String, required: true

      def destroy
        uuid = Puppetdb.client.deactivate_node(@node)
        response = { job: { uuid: uuid } }
        process_success response
      end

      api :PUT, '/puppetdb_nodes/:id/import/', N_('Import PuppetDB Node to Foreman Host')
      param :id, :identifier, required: true

      def import
        facts = Puppetdb.client.facts(@node)
        @host = PuppetdbHost.new(facts: facts).to_host
      end

      # Overrides because PuppetDB is not backed by ActiveRecord
      def resource_name
        'node'
      end

      def resource_scope
        @nodes
      end

      private

      def find_node
        @node = params[:id]
      end

      def action_permission
        case params[:action]
        when 'unknown'
          'index'
        else
          super
        end
      end
    end
  end
end
