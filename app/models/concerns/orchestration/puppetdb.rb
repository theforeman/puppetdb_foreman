module Orchestration
  module Puppetdb
    extend ActiveSupport::Concern

    included do
      before_destroy :queue_puppetdb_destroy
    end

    protected

    def queue_puppetdb_destroy
      return unless ::Puppetdb.ready? && errors.empty?
      queue.create(:name   => _('Deactivating node %s in PuppetDB') % self, :priority => 60,
                   :action => [self, :delPuppetdb])
    end

    def delPuppetdb
      Rails.logger.info "Deactivating node in PuppetDB: #{name}"
      ::Puppetdb.client.deactivate_node(name)
    rescue StandardError => e
      failure _("Failed to deactivate node %{name} in PuppetDB: %{message}\n ") %
              { :name => name, :message => e.message }, e
    end

    def setPuppetdb; end
  end
end
