#
# Cookbook Name:: recoverx
# Recipe:: recoverx
# Author:: elubow <eric@lubow.org>
# Description:: Install/configure RecoverX on a node
#


sudo 'recoverx' do
  user      default['datos']['recoverx']['user']
  nopass    true
  commands  ['/sbin/chkconfig', '/bin/cp']
end
