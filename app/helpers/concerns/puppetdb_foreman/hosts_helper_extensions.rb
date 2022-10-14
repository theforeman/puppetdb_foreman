# frozen_string_literal: true

module PuppetdbForeman
  module HostsHelperExtensions
    extend ActiveSupport::Concern

    module Overrides
      def show_appropriate_host_buttons(host)
        buttons = super

        if host.puppet_proxy_id?
          buttons << link_to_if_authorized(
            _('Puppet Classes'),
            hash_for_puppetdb_foreman_node_path(id: host.name),
            title: _('Browse host puppet classes'),
            class: 'btn btn-default'
          )
        end

        buttons.compact
      end
    end

    included do
      prepend Overrides
    end
  end
end
