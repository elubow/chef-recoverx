# *nix user that Datos client runs under
default['datos']['recoverx']['mongodb']['user'] = 'datos_user'
default['datos']['recoverx']['mongodb']['user_homedir'] = "/home/#{default['datos']['recoverx']['mongodb']['user']}"
default['datos']['recoverx']['mongodb']['uid'] = '1001'

# the group that mongo runs under
default['datos']['recoverx']['mongodb']['run_group'] = 'mongo'
