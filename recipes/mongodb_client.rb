#
# Cookbook Name:: recoverx
# Recipe:: mongodb_client
# Author:: elubow <eric@lubow.org>
# Description:: Configure a mongodb node to backup to RecoverX
#

# tag the node so we can search for it in the hosts file later
tag('recoverx_mongodb_client')

# probably should factor out the user stuff in to it's own recipe
ohai 'reload_passwd' do
  action :nothing
  if Ohai::VERSION >= '7.0.0'
    plugin 'etc'
  else
    plugin 'passwd'
  end
end

group node['datos']['recoverx']['mongodb']['group'] do
  gid node['datos']['recoverx']['mongodb']['gid']
  action :create
end

user node['datos']['recoverx']['mongodb']['user'] do
  manage_home true
  comment 'Default user for Datos RecoverX'
  uid node['datos']['recoverx']['mongodb']['uid']
  gid node['datos']['recoverx']['mongodb']['gid']
  action :create
end

ohai 'reload_passwd'

# Make sure the home directory has the proper permissions
execute 'chmod datos user directory' do
  command "chmod -R u+w #{default['datos']['recoverx']['mongodb']['user_homedir']}"
  user 'root'
  action :run
end

# Ensure the mongodb directories have the correct modes
execute 'chmod mongodb directory' do
  command "chmod 755 #{node['datos']['recoverx']['mongodb']['mongodb_dir']}"
  user 'root'
  action :run
end

execute 'chmod mongodb data directory' do
  command "chmod -R 755 #{node['datos']['recoverx']['mongodb']['mongodb_data_dir']}"
  user 'root'
  action :run
end

include_recipe 'recoverx::hosts'
