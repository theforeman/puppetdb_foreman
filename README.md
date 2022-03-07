# puppetdb\_foreman

[![Code Climate](https://codeclimate.com/github/theforeman/puppetdb_foreman/badges/gpa.svg)](https://codeclimate.com/github/theforeman/puppetdb_foreman)
[![Gem Version](https://badge.fury.io/rb/puppetdb_foreman.svg)](http://badge.fury.io/rb/puppetdb_foreman)

This is a [Foreman](http://theforeman.org) plugin to interact with [PuppetDB](https://docs.puppetlabs.com/puppetdb/index.html).

It does the following:

  * Disables hosts on PuppetDB after they are deleted in Foreman.
  * Compares nodes in PuppetDB to Hosts in Foreman.
  * Creates Hosts in Foreman from PuppetDB facts.

Feel free to raise issues, ask for features, anything, in the github repository or #theforeman IRC channel in Freenode.

## Compatibility

| Foreman Version | Plugin Version |
| --------------- | -------------- |
| >= 1.17         | ~> 4.0.0       |
| >= 1.20         | ~> 5.0.0       |
| >= 3.1          | ~> 6.0.0       |

# Installation:

**From packages**

Set up the appropriate repository by following [these instructions](https://theforeman.org/plugins/)

*RPM* users can install the `tfm-rubygem-puppetdb_foreman` (el7) or `rubygem-puppetdb_foreman` (f24) packages.

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

Go to Administer > Settings > PuppetDB and set `puppetdb_address` with your PuppetDB address, `puppetdb_enabled` to either true or false if you want to enable or disable PuppetDB integration. Obviously you will need a PuppetDB instance at the address you provide.

# Copyright:
Copyright 2013 CERN, Switzerland and various authors

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
