module PuppetdbForeman
  module HostExtensions
    extend ActiveSupport::Concern
    included do
      before_destroy :deactivate_host
      after_build :deactivate_host

      def deactivate_host
        Foreman::Logging.logger('puppetdb_foreman').debug "Deactivating host #{name} in Puppetdb"
        return false unless puppetdb_configured?

        if puppetdb_enabled?
          begin
            uri = URI.parse(Setting[:puppetdb_address])
            req = Net::HTTP::Post.new(uri.path)
            req['Accept'] = 'application/json'

            res             = Net::HTTP.new(uri.host, uri.port)
            res.use_ssl     = uri.scheme == 'https'
            if res.use_ssl?
              if Setting[:puppetdb_ssl_ca_file]
                res.ca_file = Setting[:puppetdb_ssl_ca_file]
                res.verify_mode = OpenSSL::SSL::VERIFY_PEER
              else
                res.verify_mode = OpenSSL::SSL::VERIFY_NONE
              end
              if Setting[:puppetdb_ssl_certificate] &&
                Setting[:puppetdb_ssl_private_key]
                res.cert = OpenSSL::X509::Certificate.new(
                  File.read(Setting[:puppetdb_ssl_certificate]))
                res.key  = OpenSSL::PKey::RSA.new(
                  File.read(Setting[:puppetdb_ssl_private_key]), nil)
              end

            end

            if uri.path.start_with?("/pdb")
              Foreman::Logging.logger('puppetdb_foreman').debug "Using PuppetDB API v3"
              req.content_type = 'application/json'
              req.body = {
                 "command" => "deactivate node",
                 "version" => 3,
                 "payload" => {
                   "certname" => name,
                   "producer_timestamp" => "#{Time.now.iso8601}"
                 }
               }.to_json
            else
              Foreman::Logging.logger('puppetdb_foreman').debug "Using PuppetDB API v1"
              req.body = 'payload={"command":"deactivate node","version":1,"payload":"\"'+name+'\""}'
            end
            res.start do |http|
                response = http.request(req)
                Foreman::Logging.logger('puppetdb_foreman').debug ("Response: #{response.body}")
                Foreman::Logging.logger('puppetdb_foreman').debug ("Response Code: #{response.code}")
            end

          rescue => e
            errors.add(:base, _("Could not deactivate host on PuppetDB: #{e}"))
          end
          errors.empty?
        end
      end

      private

      def puppetdb_configured?
        if puppetdb_enabled? && Setting[:puppetdb_address].blank?
          errors.add(:base, _("PuppetDB plugin is enabled but not configured. Please configure it before trying to delete a host."))
        end
        errors.empty?
      end

      def puppetdb_enabled?
        [true, 'true'].include? Setting[:puppetdb_enabled]
      end
    end
  end
end
