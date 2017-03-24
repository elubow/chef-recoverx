# Prepare the data structures
default['datos'] = {}
default['datos']['recoverx'] = {}

# Enable service during startup and start service
default['datos']['recoverx']['enabled'] = true

# datos user on the recoverx nodes
default['datos']['recoverx']['user'] = 'datos_user'
default['datos']['recoverx']['user_homedir'] = "/home/#{default['datos']['recoverx']['user']}"
default['datos']['recoverx']['uid'] = 1001

# datos group on the recoverx nodes
default['datos']['recoverx']['group'] = 'datos_user'
default['datos']['recoverx']['gid'] = 1001

# version of Datos RecoverX to install
default['datos']['recoverx']['version'] = '1.0.0'

# full URL of where to download RecoverX from
default['datos']['recoverx']['download_url'] = "http://datos.io/downloads/datos_#{default['datos']['recoverx']['version']}.tar.gz"

# default storage type for backup medium
default['datos']['recoverx']['storage']['type'] = 's3'

# default install location
default['datos']['recoverx']['install_dir'] = "/home/#{default['datos']['recoverx']['user']}"
