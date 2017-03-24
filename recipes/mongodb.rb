#
# Cookbook Name:: recoverx
# Recipe:: mongodb
# Author:: elubow <eric@lubow.org>
# Description:: Do the additional Mongodb specific configuration for RecoverX nodes
#

group node['datos']['recoverx']['mongodb']['run_group'] do
  members node['datos']['recoverx']['mongodb']['user']
  append true
  action :modify
end



# <datos_user>$sudo chown root <datos_install>/lib/fuse/bin/fusermount
# <datos_user>$sudo chmod u+s <datos_install>/lib/fuse/bin/fusermount
directory "#{node['datos']['recoverx']['install_dir']}/lib/fuse/bin/fusermount" do
  owner 'root'
  mode '4655' # 4 = suid bit, check the rest
  action :create
end

# <datos_user>$sudo modprobe fuse
execute 'modprobe_fuse' do
  command '/sbin/modprobe fuse'
  cwd "#{node['datos']['recoverx']['install_dir']}/#{node['datos']['recoverx']['version']}"
end

# mount the fusectl drive
mount '/sys/fs/fuse/connections' do
  device 'fusectl'
  fstype 'fusectl'
  action :mount
end
