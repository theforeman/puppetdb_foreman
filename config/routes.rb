Rails.application.routes.draw do
  match ':puppetdb(/*puppetdb_url)', :to => 'puppetdb_foreman/puppetdb#index', :puppetdb => /d3\.v2|charts|v3|puppetdb|metrics|\/pdb\/meta\/v1\/version\/latest|pdb\/meta\/v1\/version/, :as => "puppetdb"
end
