#
# Cookbook Name:: recoverx
# Recipe:: hosts
# Author:: elubow <eric@lubow.org>
# Description:: Adds all the relevant host file entries
#

# get all machines tagged with the following tags:
#     recoverx_client_mongo, recoverx_client_cassandra, recoverx_node

recoverx_nodes = search(:node, 'tag:recoverx_client_mongo OR tag:recoverx_client_cassandra OR tag:recoverx_node')
recoverx_nodes.each do |node|
  hostsfile_entry node['ipaddress'] do
    hostname node['fqdn']
    unique true
    action :create
  end
end
