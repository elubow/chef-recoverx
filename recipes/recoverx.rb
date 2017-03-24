#
# Cookbook Name:: recoverx
# Recipe:: recoverx
# Author:: elubow <eric@lubow.org>
# Description:: Install/configure RecoverX on a node
#

# tag the node so we can search for it in the hosts file later
tag('recoverx_node')

# probably should factor out the user stuff in to it's own recipe
ohai 'reload_passwd' do
  action :nothing
  if Ohai::VERSION >= '7.0.0'
    plugin 'etc'
  else
    plugin 'passwd'
  end
end

group node['datos']['recoverx']['group'] do
  gid node['datos']['recoverx']['gid']
  action :create
end

user node['datos']['recoverx']['user'] do
  manage_home true
  comment 'Default user for Datos RecoverX'
  uid node['datos']['recoverx']['uid']
  gid node['datos']['recoverx']['gid']
  action :create
end

ohai 'reload_passwd'

# Make sure the home directory has the proper permissions
# ensure the install directory exists
directory node['datos']['recoverx']['user_homedir'] do
  mode '0770'
  owner node['datos']['recoverx']['user']
  group node['datos']['recoverx']['group']
  action :create
end

# ensure sudo capabilities are met for the recoverx nodes
sudo 'recoverx' do
  user      node['datos']['recoverx']['user']
  nopasswd  true
  commands  ['/sbin/chkconfig', '/bin/cp']
end

# set the system wide limits
limits_config 'system-wide limits' do
  limits [
    { domain: '*', type: 'hard', item: 'nproc', value: 'unlimited' },
    { domain: '*', type: 'soft', item: 'nproc', value: 'unlimited' },
    { domain: '*', type: 'hard', item: 'nofile', value: 64000 },
    { domain: '*', type: 'soft', item: 'nofile', value: 64000 },
  ]
end

# set the nproc limits locally
limits_config '90-nproc' do
  limits [
    { domain: '*', type: 'hard', item: 'nproc', value: 'unlimited' },
    { domain: '*', type: 'soft', item: 'nproc', value: 'unlimited' },
  ]
end

# TODO Check to see if the /tmp dir has > 2G of free space on the partition

include_recipe 'recoverx::hosts'

if node['datos']['recoverx']['storage_type'].downcase == 'nfs'
  # TODO implement support for NFS mounts
  # uid/gid's must match for NFS setup
  if node['datos']['recoverx']['uid'] != node['datos']['recoverx']['gid']
    Chef::Log.error "uid #{node['datos']['recoverx']['uid']} != gid #{node['datos']['recoverx']['gid']} - RecoverX will not work properly under these circumstances ... skipping"
    return
  end
elsif node['datos']['recoverx']['storage_type'].downcase == 'gcs'
  # TODO implement support for Google Cloud Storage
  return
elsif node['datos']['recoverx']['storage_type'].downcase == 's3'
else
  # if we make it here, then we don't have a valid storage type and need to bail
  return
end

# ensure the install directory exists
directory node['datos']['recoverx']['install_dir'] do
  mode '0770'
  owner node['datos']['recoverx']['user']
  group node['datos']['recoverx']['group']
  action :create
end

# download the tarball and put it in the install directory
remote_file "#{node['datos']['recoverx']['install_dir']}/datos.tar.gz"  do
  source node['datos']['recoverx']['download_url']
  owner node['datos']['recoverx']['user']
  group node['datos']['recoverx']['group']
  mode '0755'
  action :create_if_missing
end

# untar the install tarball
include_recipe 'tarball::default'
tarball "#{node['datos']['recoverx']['install_dir']}/datos.tar.gz"  do
  destination node['datos']['recoverx']['install_dir']
  owner node['datos']['recoverx']['user']
  group node['datos']['recoverx']['group']
  not_if { ::File.directory?("#{node['datos']['recoverx']['install_dir']}/datos_#{node['datos']['recoverx']['version']}") }
  action :extract
end

# TODO Need to come up with a better way to get the IP address
local_ipv4 = node['network']['interfaces']['eth0']['addresses'].keys[1]

# Ensure python2.6 is installed
# matching command: add-apt-repository ppa:fkrull/deadsnakes
case node[:platform]
when 'ubuntu'
  apt_repository 'fkrull-deadsnakes' do
    uri          'ppa:fkrull/deadsnakes'
    distribution node['lsb']['codename']
  end
when 'redhat', 'centos'
end

# we need to ensure that Python 2.6 is installed for the installer
%w{python2.6 libpython2.6}.each do |pkg|
  package pkg do
    action :install
  end
end

# Decide whether or not we need to include the --no-nfs switch in the installer
do_nfs = node['datos']['recoverx']['storage_type'].downcase != 'nfs' ?
  '--no-nfs' :
  ''

execute 'install_recoverx' do
  command "./install_datos --skip-eula-check --ip-address #{local_ipv4} --target-dir #{node['datos']['recoverx']['install_dir']} #{do_nfs}"
  user node['datos']['recoverx']['user']
  group node['datos']['recoverx']['group']
  cwd "#{node['datos']['recoverx']['install_dir']}/datos_#{node['datos']['recoverx']['version']}"
end

# Do the extra Mongodb specific tasks
case node['datos']['recoverx']['node_type'].downcase
when 'mongodb'
  include_recipe 'recoverx::mongodb'
when 'cassandra'
  include_recipe 'recoverx::cassandra'
end
