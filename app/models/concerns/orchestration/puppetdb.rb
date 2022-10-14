# frozen_string_literal: true

module Orchestration
  module Puppetdb
    extend ActiveSupport::Concern

    included do
      before_destroy :queue_puppetdb_destroy
    end

    protected

    def queue_puppetdb_destroy
      return unless ::Puppetdb.ready? && errors.empty?
      queue.create(
        name: _('Deactivating node %s in PuppetDB') % self,
        priority: 60,
        action: [self, :del_puppetdb]
      )
    end

    def del_puppetdb
      Rails.logger.info "Deactivating node in PuppetDB: #{name}"
      ::Puppetdb.client.deactivate_node(name)
    rescue StandardError => e
      failure format(
        _("Failed to deactivate node %<name>s in PuppetDB: %<message>s\n "), name: name, message: e.message
      ), e
    end

    def set_puppetdb
    end
  end
end
