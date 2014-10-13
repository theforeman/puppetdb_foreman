# puppetdb\_foreman

This is a [Foreman](http://theforeman.org) plugin to interact with [PuppetDB](https://docs.puppetlabs.com/puppetdb/index.html).

It does the following:

  1. Disables hosts on PuppetDB after they are deleted in Foreman.
  2. Proxies the PuppetDB Performance Dashboard for access through Foreman.

Feel free to raise issues, ask for features, anything, in the github repository or #theforeman IRC channel in Freenode.

# Installation:

**From packages**

Set up the appropriate repository by following [these instructions](http://theforeman.org/manuals/1.6/index.html#3.3InstallFromPackages)

*RPM* users can install the `ruby193-rubygem-puppetdb_foreman` (SCL) or `rubygem-puppetdb_foreman` (non SCL) packages.

*deb* users can install the `ruby-puppetdb-foreman` package.

**From Rubygems**

Add to bundler.d/Gemfile.local.rb as:

    gem 'puppetdb_foreman'

then update & restart Foreman:

    bundle update

    service restart foreman or equivalent


**Versioning**

puppetdb_foreman uses [Semantic Versioning 2.0.0](http://semver.org/spec/v2.0.0.html)

# Usage:

Go to Administer > Settings > PuppetDB and set `puppetdb_address` with your PuppetDB address, `puppetdb_dashboard_address` (optional) to proxy the dashboard, `puppetdb_enabled` to either true or false if you want to enable or disable PuppetDB integration. Obviously you will need a PuppetDB instance at the address you provide.

Alternatively you can put your settings in `config/settings.yaml`. Please keep in mind these will be overwritten if changed in the application, and if the application is rebooted, YAML rules will overwrite again your manually changed settings. Hence passing your settings in this format is discouraged, but allowed.
```yaml
:puppetdb:
  :enabled: true
  :address: 'https://puppetdb:8081/v2/commands'
  :dashboard_address: 'http://puppetdb:8080/dashboard'
```

You can find the dashboard under Monitor > PuppetDB dashboard. Only administrators and users with a role `view_puppetdb_dashboard` will be able to access it. Aside from convenience, the PuppetDB dashboard cannot be served over HTTPS, you can restrict your dashboard requests to only Foreman boxes and serve it securely to your users through HTTPS in Foreman.

![Screenshot](http://i.imgur.com/5d80CtZ.png)


# Copyright:
Copyright 2013 CERN, Switzerland

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


