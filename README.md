# Puppetdb\_foreman

This is a foreman plugin to interact with puppetdb through callbacks.
At the moment it basically disables hosts on puppetdb after they are deleted in Foreman.
Feel free to raise issues, ask for features, anything, in the github repository.

# Installation:

Add to bundler.d/Gemfile.local.rb as:

    gem 'puppetdb_foreman'

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


