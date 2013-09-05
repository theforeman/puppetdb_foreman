# Puppetdb\_foreman

This is a foreman plugin to interact with puppetdb through callbacks.

# Installation:

Add to bundler.d/Gemfile.local.rb as:

    gem 'puppetdb\_foreman'

then update & restart Foreman:

    bundle update
    

# Usage:


Add to your Foreman `config/settings.yaml`:

```yaml
:puppetdb:
  :enabled: true
  :address: 'https://puppetdb:8081/v2/commands'
```

Obviously you will need a puppetdb instance at the address you provide.

# Copyright

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
