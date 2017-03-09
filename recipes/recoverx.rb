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
