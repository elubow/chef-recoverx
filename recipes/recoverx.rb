#
# Cookbook Name:: recoverx
# Recipe:: recoverx
# Author:: elubow <eric@lubow.org>
# Description:: Install/configure RecoverX on a node
#

# tag the node so we can search for it in the hosts file later
tag('recoverx_node')

# ensure sudo capabilities are met for the recoverx nodes
sudo 'recoverx' do
  user      default['datos']['recoverx']['user']
  nopass    true
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

# XXX this may or may not work properly
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
  action :create
  mode '0770'
  owner node['datos']['recoverx']['user']
  group node['datos']['recoverx']['group']
end

# download the tarball and put it in the install directory
remote_file "#{node['datos']['recoverx']['install_dir']}/datos.tar.gz"  do
  source node['datos']['recoverx']['download_url']
end

# untar the install tarball
include_recipe 'tarball::default'
tarballx "#{node['datos']['recoverx']['install_dir']}/datos.tar.gz"  do
  destination node['datos']['recoverx']['install_dir']
  owner      default['datos']['recoverx']['user']
  group      default['datos']['recoverx']['group']
  action :extract
end

# TODO Need to come up with a better way to get the IP address
local_ipv4 = node['network']['interfaces']['eth1']['addresses'].keys[1]

exec 'install_recoverx' do
  command "./install_datos --ip-address #{local_ipv4} --target-dir #{node['datos']['recoverx']['install_dir']}"
  cwd "#{node['datos']['recoverx']['install_dir']}/#{node['datos']['recoverx']['version']}"
end

# Do the extra Mongodb specific tasks
if node['datos']['recoverx']['node_type'].downcase == 'mongodb'

  # XXX Convert these to chef commands
  # <datos_user>$sudo chown root <datos_install>/lib/fuse/bin/fusermount
  # <datos_user>$sudo chmod u+s <datos_install>/lib/fuse/bin/fusermount
  directory "#{node['datos']['recoverx']['install_dir']}/lib/fuse/bin/fusermount" do
    owner 'root'
    mode '4655' # 4 = suid bit, check the rest
    action :create
  end

  # <datos_user>$sudo modprobe fuse
  exec 'modprobe_fuse' do
    command '/sbin/modprobe fuse'
    cwd "#{node['datos']['recoverx']['install_dir']}/#{node['datos']['recoverx']['version']}"
  end


  # mount the fusectl drive
  mount '/sys/fs/fuse/connections' do
    device 'fusectl'
    fstype 'fusectl'
    action :mount
  end
  

end
