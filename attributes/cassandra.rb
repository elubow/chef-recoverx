# *nix user that Datos client runs under
default['datos']['recoverx']['cassandra']['user'] = 'datos_user'
default['datos']['recoverx']['cassandra']['user_homedir'] = "/home/#{default['datos']['recoverx']['cassandra']['user']}"
default['datos']['recoverx']['cassandra']['uid'] = '1001'

# *nix group that Cassandra runs under
default['datos']['recoverx']['cassandra']['run_group'] = 'cassandra'

# location of Cassandra directories
default['datos']['recoverx']['cassandra']['cassandra_dir'] = '/var/lib/cassandra'
default['datos']['recoverx']['cassandra']['cassandra_data_dir'] = '/var/lib/cassandra/data'
