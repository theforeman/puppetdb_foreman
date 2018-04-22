Rails.application.routes.draw do
  get ':puppetdb/(*puppetdb_url)', to: 'puppetdb_foreman/puppetdb#index', constraints: { puppetdb_url: %r{.*}, puppetdb: /puppetdb|pdb/ }

  namespace :puppetdb_foreman do
    constraints(:id => %r{[^\/]+}) do
      resources :nodes, :only => [:index, :destroy] do
        member do
          put 'import'
        end
      end
    end
  end

  namespace :api, :defaults => { :format => 'json' } do
    scope '(:apiv)', :module => :v2,
                     :defaults => { :apiv => 'v2' },
                     :apiv => /v1|v2/,
                     :constraints => ApiConstraints.new(:version => 2) do
      constraints(:id => /[^\/]+/) do
        resources :puppetdb_nodes, :only => [:index, :destroy] do
          collection do
            get 'unknown'
          end
          member do
            put 'import'
          end
        end
      end
    end
  end
end
