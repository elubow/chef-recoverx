#
# Cookbook Name:: recoverx
# Recipe:: cassandra
# Author:: elubow <eric@lubow.org>
# Description:: Do the additional Cassandra specific configuration for RecoverX nodes
#

# ensure that datos_user is part of the cassandra group
group node['datos']['recoverx']['cassandra']['run_group'] do
  members node['datos']['recoverx']['cassandra']['user']
  append true
  action :modify
end
