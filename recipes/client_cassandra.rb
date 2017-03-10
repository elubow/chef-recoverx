#
# Cookbook Name:: recoverx
# Recipe:: client_cassandra
# Author:: elubow <eric@lubow.org>
# Description:: Configure a cassandra node to backup to RecoverX
#

# tag the node so we can search for it in the hosts file later
tag('recoverx_client_cassandra')


user default['datos']['recoverx']['cassandra']['user'] do
  comment 'Default user for Datos RecoverX'
  home node['datos']['recoverx']['cassandra']['user_homedir']
  uid node['datos']['recoverx']['cassandra']['uid']
  gid node['datos']['recoverx']['cassandra']['group']
  action :create
end

# Make sure the home directory has the proper permissions
execute 'chmod datos user directory' do
  command "chmod -R u+w #{default['datos']['recoverx']['cassandra']['user_homedir']}"
  user 'root'
  action :run
end

# Ensure the cassandra directories have the correct modes
execute 'chmod cassandra directory' do
  command "chmod 755 #{default['datos']['recoverx']['cassandra']['cassandra_dir']}"
  user 'root'
  action :run
end

execute 'chmod cassandra data directory' do
  command "chmod -R 755 #{default['datos']['recoverx']['cassandra']['cassandra_data_dir']}"
  user 'root'
  action :run
end

include_recipe 'recoverx::hosts'
