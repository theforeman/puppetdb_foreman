module PuppetdbForeman
  class PuppetdbController < ApplicationController
    protect_from_forgery :except => :index
    prepend_before_action :allow_google_fonts

    def index
      uri = URI.parse(Setting[:puppetdb_dashboard_address])

      if params[:puppetdb_url].blank?
        redirect_to status: :found, action: :index, puppetdb_url: "#{uri.path}/"
        return
      end

      if params[:puppetdb] == 'puppetdb'
        request_url = params[:puppetdb_url]
      elsif params[:puppetdb] == 'pdb'
        request_url = "pdb/#{params[:puppetdb_url]}"
      end
      puppetdb_mapping = map_to_puppetdb_url(request_url, uri)
      puppetdb_url = puppetdb_mapping[:path]

      logger.info "PuppetDB: Proxying '#{params[:puppetdb_url]}' to '#{uri.scheme}://#{uri.host}:#{uri.port}/#{puppetdb_url}' as #{puppetdb_mapping[:content_type]}"

      @result = Net::HTTP.get_response(uri.host, puppetdb_url, uri.port)

      unless puppetdb_mapping[:layout]
        respond_to do |format|
          format.any do
            render body: @result.body, content_type: puppetdb_mapping[:content_type], status: :ok
          end
          format.json do
            render json: @result.body
          end
        end
      end
    rescue SocketError
      @proxy_error = "Problem connecting to host #{uri.host} on port #{uri.port}"
      render :action => :error, :layout => true
    rescue Errno::ECONNREFUSED
      @proxy_error = "#{uri.host} refused our connection"
      render :action => :error, :layout => true
    rescue EOFError
      @proxy_error = "Don't use ssl (https)"
      render :action => :error, :layout => true
    end

    # Override from application controller to fix issue
    def api_request?
      request.format && (request.format.json? || request.format.yaml?)
    end

    private

    def map_to_puppetdb_url(request_url, uri)
      case request_url
      when /\.js$/
        { path: "/#{request_url}", content_type: Mime[:js], layout: false }
      when /^v3/, /^metrics/, /^pdb\/meta/, /^pdb\/dashboard\/data/
        { path: "/#{request_url}", content_type: Mime[:json], layout: false }
      else
        { path: "#{uri.path}/index.html", content_type: Mime[:html], layout: true }
      end
    end

    def allow_google_fonts
      append_content_security_policy_directives(style_src: ['https://fonts.googleapis.com/'])
    end
  end
end
