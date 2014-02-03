#
# Copyright 2013 CERN, Switzerland
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module PuppetdbForeman
  class Engine < ::Rails::Engine

    config.to_prepare do
      if SETTINGS[:version].to_s.to_f >= 1.2
        # Foreman 1.2
        Host::Managed.send :include, PuppetdbForeman::HostExtensions
      else
        # Foreman < 1.2
        Host.send :include, PuppetdbForeman::HostExtensions
      end
    end

  end
end
