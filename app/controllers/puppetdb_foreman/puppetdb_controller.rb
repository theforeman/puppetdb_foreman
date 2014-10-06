module PuppetdbForeman
  class PuppetdbController < ApplicationController

    def index
      begin
        uri = URI.parse(Setting[:puppetdb_dashboard_address])
        puppetdb_url = case params[:puppetdb]
                       when 'd3.v2', 'charts' then "#{uri.path}#{request.original_fullpath}"
                       when 'v3'              then request.original_fullpath
                       else                        "#{uri.path}/index.html"
                       end
        result = Net::HTTP.get_response(uri.host, puppetdb_url, uri.port)
        # render error if result. ...
        render :text => result.body
      rescue SocketError => error
        render :text => 'Error Proxying PuppetDB Dashboard: maybe you need to set "puppetdb_dashboard_address"'
      end
    end

    # Override from application controller to fix issue
    def api_request?
      request.format and (request.format.json? or request.format.yaml?)
    end

  end
end
