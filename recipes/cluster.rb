#
# Copyright 2014 John Bellone <jbellone@bloomberg.net>
# Copyright 2014 Bloomberg Finance L.P.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

tag('consul_cluster') if node[consul][service_mode] == 'cluster'

nodes = search('node', 'tags:consul_cluster'\
    " AND chef_environment:#{node.chef_environment}")
  Chef::Log.debug("Found consul nodes at #{nodes.join(', ').inspect}")

node.set['consul']['servers'] = nodes.join(',')

if node['consul']['servers'].to_i >= node['consul']['bootstrap_expect']
  node.set['consul']['retry_on_join'] = true
end
