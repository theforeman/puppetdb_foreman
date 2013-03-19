module PuppetdbForeman
  module HostExtensions 
    extend ActiveSupport::Concern
    included do
      after_destroy :deactivate_host

      def deactivate_host
        logger.debug "Deactivating host #{name} in Puppetdb"                       
        if SETTINGS[:puppetdb][:enabled] && SETTINGS[:puppetdb][:address].present?
          begin                                                            
            uri = URI.parse(SETTINGS[:puppetdb][:address])            
            req = Net::HTTP::Post.new(uri.path) 
            req['Accept'] = 'application/json'
            req.set_form_data('payload' => { 'command' => 'deactivate node','version' => 1, 'payload' => "#{name}" })
            res             = Net::HTTP.new(uri.host, uri.port)           
            res.use_ssl     = uri.scheme == 'https'                       
            if res.use_ssl?                                               
              if Setting[:ssl_ca_file] 
                res.ca_file = Setting[:ssl_ca_file]                           
                res.verify_mode = OpenSSL::SSL::VERIFY_PEER               
              else 
                res.verify_mode = OpenSSL::SSL::VERIFY_NONE 
              end 
              if Setting[:ssl_certificate] && Setting[:ssl_priv_key]
                res.cert = OpenSSL::X509::Certificate.new(File.read(Setting[:ssl_certificate]))
                res.key  = OpenSSL::PKey::RSA.new(File.read(Setting[:ssl_priv_key]), nil)
              end                                                         
            end                                                           
            res.start { |http| http.request(req) }                        
          rescue => e 
            raise "Could not deactivate host: #{e}" 
          end 
        end
      end
    end
  end
end
