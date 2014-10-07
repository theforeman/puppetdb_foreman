# Puppetdb\_foreman

This is a foreman plugin to interact with puppetdb.
At the moment it basically does the following:

  1. Disables hosts on puppetdb after they are deleted in Foreman.
  2. Proxies the PuppetDB Performance Dashboard for access through Foreman.

Feel free to raise issues, ask for features, anything, in the github repository.

# Installation:

**From packages**

Set up the appropriate repository by following [these instructions](http://theforeman.org/manuals/1.5/index.html#3.3InstallFromPackages)

RPM users can install the "ruby193-rubygem-puppetdb_foreman" or "rubygem-puppetdb_foreman" packages.

Deb users can install the "ruby-puppetdb-foreman" package.

**From Rubygems**

Add to bundler.d/Gemfile.local.rb as:

    gem 'puppetdb_foreman'

then update & restart Foreman:

    bundle update


# Usage:

Go to Administer > Settings > PuppetDB and set `puppetdb_address` with your PuppetDB address, `puppetdb_enabled` to either true or false if you want to enable or disable PuppetDB integration. Obviously you will need a PuppetDB instance at the address you provide.

*If you are upgrading from < 0.0.5, your settings will be imported from `config/settings.yaml`.*

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


