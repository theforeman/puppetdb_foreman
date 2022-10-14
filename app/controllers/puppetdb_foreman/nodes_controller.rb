# frozen_string_literal: true

module PuppetdbForeman
  class NodesController < ApplicationController
    before_action :find_node, only: %i[show destroy import]

    def controller_permission
      'puppetdb_nodes'
    end

    def index
      @foreman_hosts = Host.unscoped.pluck(:name)
      @puppetdb_hosts = Puppetdb.client.query_nodes
      @unknown_hosts = @puppetdb_hosts - @foreman_hosts
    end

    def show # rubocop:disable Metrics/AbcSize
      response = Puppetdb.client.resources(@node)

      class_names = response.map { |v| v['title'] if v['type'] == 'Class' }.compact

      @classes_count = class_names.count
      @classes = class_names.paginate(page: params[:page], per_page: params[:per_page])

      @type_names = response.map { |v| v['type'] }.uniq
    end

    def destroy
      Puppetdb.client.deactivate_node(@node)
      process_success(
        success_msg: _('Deactivated node %s in PuppetDB') % @node,
        success_redirect: puppetdb_foreman_nodes_path
      )
    rescue StandardError => e
      process_error(
        redirect: puppetdb_foreman_nodes_path,
        error_msg: _('Failed to deactivate node in PuppetDB: %s') % e.message
      )
    end

    def import # rubocop:disable Metrics/MethodLength
      facts = Puppetdb.client.facts(@node)
      host = PuppetdbHost.new(facts: facts).to_host
      process_success(
        success_msg: _('Imported host %s from PuppetDB') % @node,
        success_redirect: host_path(id: host)
      )
    rescue StandardError => e
      process_error(
        redirect: puppetdb_foreman_nodes_path,
        error_msg: _('Failed to import host from PuppetDB: %s') % e.message
      )
    end

    private

    def action_permission
      case params[:action]
      when 'import'
        'import'
      else
        super
      end
    end

    def find_node
      @node = params[:id]
    end
  end
end
