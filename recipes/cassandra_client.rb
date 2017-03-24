#
# Cookbook Name:: recoverx
# Recipe:: cassandra_client
# Author:: elubow <eric@lubow.org>
# Description:: Configure a cassandra node to backup to RecoverX
#

# tag the node so we can search for it in the hosts file later
tag('recoverx_cassandra_client')

# probably should factor out the user stuff in to it's own recipe
ohai 'reload_passwd' do
  action :nothing
  if Ohai::VERSION >= '7.0.0'
    plugin 'etc'
  else
    plugin 'passwd'
  end
end

group node['datos']['recoverx']['cassandra']['group'] do
  gid node['datos']['recoverx']['cassandra']['gid']
  action :create
end

user node['datos']['recoverx']['cassandra']['user'] do
  manage_home true
  comment 'Default user for Datos RecoverX'
  uid node['datos']['recoverx']['cassandra']['uid']
  gid node['datos']['recoverx']['cassandra']['gid']
  action :create
end

ohai 'reload_passwd'

# Make sure the home directory has the proper permissions
execute 'chmod datos user directory' do
  command "chmod -R u+w #{default['datos']['recoverx']['cassandra']['user_homedir']}"
  user 'root'
  action :run
end

# Ensure the cassandra directories have the correct modes
execute 'chmod cassandra directory' do
  command "chmod 755 #{node['datos']['recoverx']['cassandra']['cassandra_dir']}"
  user 'root'
  action :run
end

execute 'chmod cassandra data directory' do
  command "chmod -R 755 #{node['datos']['recoverx']['cassandra']['cassandra_data_dir']}"
  user 'root'
  action :run
end

include_recipe 'recoverx::hosts'
